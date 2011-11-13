require "tmpdir"

module HubotFactory
  class HttpPost
    include HTTParty
    default_params :output => "json"
    format :json
  end

  class BuildHubot
    @queue = :build_hubot

    # Builds and deploys a Hubot instance to Heroku.
    #
    # email        - A String of the email of the target Heroku account.
    # name         - A String of the name of the robot.
    # url          - A String of a URL to send a notification to.
    # adapter      - A String of the adapter for the robot.
    # adapter_vars - An Array of Hashes of environment variables to set.
    #
    # Returns nothing.
    def self.perform(email, name, url, adapter, adapter_vars)
      process = if adapter.downcase == "twilio"
        "web"
      else
        "app"
      end

      Dir.chdir(Dir.mktmpdir("#{name}-"))

      Hubot.create(Settings.secrets["hubot_bin"], name)
      Hubot.procfile(name, adapter, process)

      Git.init
      Git.add
      Git.commit

      Heroku.create
      Heroku.config(adapter_vars)

      Git.push

      Heroku.scale(process)
      Heroku.transfer(email, Settings.secrets["heroku_user"])

      adapter_vars.each do |v|
        if v["var"].downcase.include?("password") ||
          v["var"].downcase.include?("token")

          v["val"] = "*********"
        end
      end

      Email.send_notification(email, name, adapter, adapter_vars)

      if url
        json = { :email => email, :name => name, :adapter => adapter }.to_json
        HttpPost.post(url, :body => json)
      end
    end
  end
end
