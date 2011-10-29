require "sinatra/base"
require "mustache/sinatra"

require "views/layout"

module HubotFactory
  class App < Sinatra::Base
    register Mustache::Sinatra

    dir = File.expand_path("../../../", __FILE__)

    set :root,   dir
    set :static, true

    set :mustache, {
      :namespace => HubotFactory,
      :views     => "#{dir}/views",
      :templates => "#{dir}/templates"
    }

    get "/" do
      mustache :index
    end

    post "/build" do
      params.inspect
    end

  end
end
