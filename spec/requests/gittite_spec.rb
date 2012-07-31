require 'spec_helper.rb'
require "net/http"

describe Gittite do
  def data
    {'payload' => {
        "repository" => {
          "url" => "http://github.com/granify/store_spree",
          "name" => "store_spree",
          "owner" => {
            "name" => "granify"
          }
        },
        "ref" => "refs/heads/master"
      }.to_json
    }
  end

  def make_request(uri, data)
    net = Net::HTTP.new("localhost",9900)
    req = Net::HTTP::Post.new(uri)
    req["content-type"] = "application/json"
    req.body = data.to_json

    resp = net.start do |http|
      http.request(req)
    end
    resp.header.class.should == Net::HTTPOK
    resp
  end

  it "should return 200" do
    resp = make_request('/', data)
    p resp.header.class
  end
end