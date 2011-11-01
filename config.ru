$: << File.expand_path("../lib", __FILE__) << File.expand_path("../", __FILE__)

require "bundler/setup"
require "resque/server"
require "hubot_factory"

Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user == HubotFactory::Settings.secrets["resque_user"] &&
  password == HubotFactory::Settings.secrets["resque_pass"]
end

map "/" do
  run HubotFactory::App
end

map "/resque" do
  run Resque::Server
end
