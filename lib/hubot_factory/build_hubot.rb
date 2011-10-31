require "tmpdir"

module HubotFactory
  class BuildHubot
    @queue = :build_hubot

    # Builds and deploys a Hubot instance to Heroku.
    #
    # email        - A String of the email of the target Heroku account.
    # name         - A String of the name of the robot.
    # adapter      - A String of the adapter for the robot.
    # adapter_vars - An Array of Hashes of environment variables to set.
    #
    # Returns nothing.
    def self.perform(email, name, adapter, adapter_vars)
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

      Email.send_notification(email, name, adapter, adapter_vars)
    end
  end
end
