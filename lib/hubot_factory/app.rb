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

    not_found do
      @title = "Uh oh! Not Found - Hubot Factory"
      mustache :not_found
    end

    error do
      @title = "Oops! Error - Hubot Factory"
      mustache :error
    end

    get "/" do
      mustache :index
    end

    get "/api_docs" do
      mustache :api_docs
    end

    post "/build" do
      @email        = params[:email]
      @name         = params[:name]
      @adapter      = params[:adapter]
      @adapter_vars = params.keys.grep(/^adapter-/i).map do |k|
        { :var => k[8..-1], :val => params[k] }
      end

      @adapter_vars.select! do |item|
        item[:val] && item[:val] != ""
      end

      Resque.enqueue(BuildHubot, @email, @name, nil, @adapter, @adapter_vars)
      @title = "You're Hubot is being Built - Hubot Factory"
      mustache :build
    end

    get "/about" do
      @title = "About - Hubot Factory"
      mustache :about
    end
  end
end
