$: << File.expand_path("../lib", __FILE__) << File.expand_path("../", __FILE__)

require "bundler/setup"
require "hubot_factory"

map "/" do
  run HubotFactory::App
end

map "/resque" do
  run Resque::Server
end
