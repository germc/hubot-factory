$: << File.expand_path("../lib", __FILE__) << File.expand_path("../", __FILE__)

require "bundler/setup"
require "hubot_factory"

run HubotFactory::App
