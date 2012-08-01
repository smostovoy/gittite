require 'spec_helper.rb'

describe Gittite do
  def data
    {
      "repository" => {
        "url" => "http://github.com/granify/store_spree",
        "name" => "store_spree",
        "owner" => {
          "name" => "granify"
        }
      },
      "ref" => "refs/heads/master"
    }
  end

  it "clones repo" do
    opts = {log_stdout: true}
    with_api(Gittite, opts) do |server|
      get_request(data) do |c|
        p c.response
        c.response_header.status.should == 200
      end
      server.stop
    end
  end
end