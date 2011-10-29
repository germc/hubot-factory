require "heroku"
require "sinatra/base"
require "mustache/sinatra"
require "pony"
require "resque"

require "hubot_factory/settings"
require "hubot_factory/app"
require "hubot_factory/build_hubot"
require "hubot_factory/version"

Resque.redis = Redis.new(:host     => HubotFactory::Settings.secrets["redis_host"],
                         :port     => HubotFactory::Settings.secrets["redis_port"],
                         :password => HubotFactory::Settings.secrets["redis_pass"])

require "views/layout"
