require "sinatra/base"

module HubotFactory
  class App < Sinatra::Base

    get "/" do
      "<a href='http://hubot.github.com'>Hubot</a> Factory"
    end

  end
end
