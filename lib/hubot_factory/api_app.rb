module HubotFactory
  class ApiApp < Sinatra::Base
    get "/" do
      "hello world!"
    end

    post "/build" do
      unless request.media_type == "application/json"
        return {
          :success => false,
          :message => "You must send parameters as JSON"
        }.to_json
      end

      request.body.rewind
      data = JSON.parse request.body.read

      email   = data["email"]
      name    = data["name"]
      adapter = data["adapter"]
      url     = data["url"]
      vars    = data["adapter_vars"]
      
      vars    = vars.keys.map do |k|
        { :var => k, :val => vars[k] }
      end

      content_type "application/json"

      if not email
        {
          :success => false,
          :message => "You must specifiy an email"
        }.to_json
      elsif not name
        {
          :success => false,
          :message => "You must specifiy a name"
        }.to_json
      elsif not adapter
        {
          :success => false,
          :message => "You must specify an adapter"
        }.to_json
      else
        if Resque.enqueue(BuildHubot, email, name, url, adapter, vars)
          { :success => true }.to_json
        else
          { :success => false }.to_json
        end
      end
    end
  end
end
