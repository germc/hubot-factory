require "heroku"
require "sinatra/base"
require "mustache/sinatra"
require "pony"
require "resque"

require "hubot_factory/settings"
require "hubot_factory/app"
require "hubot_factory/build_hubot"
require "hubot_factory/version"

module HubotFactory
  Resque.redis = Redis.new(:host     => Settings.secrets["redis_host"],
                           :port     => Settings.secrets["redis_port"],
                           :password => Settings.secrets["redis_pass"])
end

require "views/layout"
