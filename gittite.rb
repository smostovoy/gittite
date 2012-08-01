#!/usr/bin/env ruby
$: << File.dirname(__FILE__) << File.join(File.dirname(__FILE__), 'lib')

require 'goliath'
require 'em-synchrony'
require 'pp'
require 'grit'
require 'json'

require "utils"
require "project"

class Gittite < Goliath::API
  use ::Rack::Reloader if  ARGV.index('-e') && ARGV[ARGV.index('-e') + 1] == 'test'
  use Goliath::Rack::Params
  include Utils
  include Project

  def response(environment)
    payload = JSON.parse params['payload']
    pp payload
    repo   = payload['repository']
    branch = payload["ref"].match(/\w+$/)[0]
    dir    = branch_to_dir(branch)
    env.logger.info 'Updating repo: ' + repo['name'] + '/' + branch
    @deploy_to = "#{config['deploy_path']}/#{repo['name']}"
    @deploy_path = File.join @deploy_to, dir

    EM.defer do
      begin
        update_code branch, repo['url']
        execute_after_deploy_hook
        clean_removed_branches
      rescue =>e
        env.logger.error (e.message + e.backtrace.join("\n"))
      end

      env.logger.info 'Finished'
    end

    return [200, {'Content-Type' => 'text/html'}, ["Success!"]]
  end
end