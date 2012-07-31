$: << File.dirname(__FILE__) << File.join(File.dirname(__FILE__), 'lib')

require 'goliath'
require 'em-synchrony'
require 'pp'
require 'grit'

class Gittite < Goliath::API
  use Goliath::Rack::Params

  def response(env)
    pp params
    repo = params['repository']

      branch = params["ref"].match(/\w+$/)[0]
      dir = branch.gsub('_', '-')
      env.logger.info 'Updating repo: ' + repo['name'] + '/' + branch
      deploy_path = File.join config['deploy_path'], repo['name'], dir

      if File.directory? deploy_path
          env.logger.info "Updating existing directory"
          env.logger.info `cd #{deploy_path}; git checkout #{branch}; git reset --hard; git pull`
      else
          env.logger.info `git clone -b #{branch} #{repo['url']} #{deploy_path}`
      end

      Dir.chdir(deploy_path)
      env.logger.info Dir.pwd
      git = Grit::Repo.new(deploy_path)
      begin
        env.logger.info 'looking for after_deploy file...'
        load deploy_path + "/config/github_hook_handler.rb"
        env.logger.info 'Executed after_deploy file'
      rescue LoadError=>e
        env.logger.info 'no config file in project'
      rescue =>e
        env.logger.error e.message
      end

      branches = git.branches.to_a.map { |b| b.to_s.match(/\w+$/).to_s }.uniq
      env.logger.info 'Looking for obsolete branches.........'
      env.logger.info "Active branches: #{branches.inspect}"
      env.logger.info "#{Dir.pwd}. Catalogs: "
      Dir.foreach(project['deploy_to']) { |d|
        next if branches.include?(d) or branches.include?(d.gsub('-', '_'))
        next if ['.','..'].include? d
        next unless File.directory?(File.join project['deploy_to'], d)
        env.logger.info d
        #FileUtils.rm_r File.join project['deploy_to'], d
      }
      env.logger.info 'Finished'

    return [200, {'Content-Type' => 'text/html'}, ["Success!"]]
  end
end