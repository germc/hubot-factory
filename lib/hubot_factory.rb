require "heroku"
require "sinatra/base"
require "mustache/sinatra"
require "pony"
require "resque"

require "hubot_factory/adapters"

Resque.redis = Redis.new(:host     => HubotFactory::Settings.secrets["redis_host"],
                         :port     => HubotFactory::Settings.secrets["redis_port"],
                         :password => HubotFactory::Settings.secrets["redis_pass"])

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address              => HubotFactory::Settings.secrets["email_host"],
    :port                 => HubotFactory::Settings.secrets["email_port"],
    :domain               => HubotFactory::Settings.secrets["email_domain"],
    :user_name            => HubotFactory::Settings.secrets["email_user"],
    :password             => HubotFactory::Settings.secrets["email_pass"],
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
}

require "hubot_factory/build_hubot"
require "hubot_factory/settings"
require "hubot_factory/app"
require "hubot_factory/version"

require "views/layout"
