module HubotFactory
  class ApiApp < Sinatra::Base
    get "/" do
      "hello world!"
    end

    post "/build" do
      @email   = params[:email]
      @name    = params[:name]
      @adapter = params[:adapter]
      @url     = params[:url]

      @vars    = params.keys.grep(/^adapter-/i).map do |k|
        { :var => k[8..-1], :val => params[k] }
      end

      @vars.select! do |item|
        item[:val] && item[:val] != ""
      end

      content_type "application/json"

      if not @email
        {
          :success => false,
          :message => "You must specifiy an email"
        }.to_json
      elsif not @name
        {
          :success => false,
          :message => "You must specifiy a name"
        }.to_json
      elsif not @adapter
        {
          :success => false,
          :message => "You must specify an adapter"
        }.to_json
      else
        if Resque.enqueue(BuildHubot, @email, @name, @url, @adapter, @vars)
          { :success => true }.to_json
        else
          { :success => false }.to_json
        end
      end
    end
  end
end
