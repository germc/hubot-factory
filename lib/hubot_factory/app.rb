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
      @email   = params[:email]
      @name    = params[:name]
      @adapter = params[:adapter]
      @scripts = params[:scripts]

      Resque.enqueue(BuildHubot, @email, @name, @adapter, @scripts)

      mustache :build
    end

  end
end
