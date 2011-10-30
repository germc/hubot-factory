require "tmpdir"

module HubotFactory
  class BuildHubot
    @queue = :build_hubot

    def self.perform(email, name, adapter, adapter_vars)

      adapter = "shell" unless valid_adapters.include? adapter

      config = adapter_vars.map do |item|
        "#{item["var"]}=\"#{item["val"]}\""
      end

      dir = Dir.mktmpdir "#{name}-"

      system "#{Settings.secrets["hubot_bin"]} -c #{dir} -n #{name}"
      system "sed", "-i", "s/-n Hubot/-n #{name}/", "#{dir}/Procfile"
      system "sed", "-i", "s/-a campfire/-a #{adapter}/", "#{dir}/Procfile"
      system "cd #{dir} && git init && git add . && git commit -m 'Initial commit'"
      system "cd #{dir} && heroku create -s cedar"
      system "cd #{dir} && heroku config:add #{config.join(" ")}"
      system "cd #{dir} && git push heroku master"
      system "cd #{dir} && heroku ps:scale app=1"
      system "cd #{dir} && heroku sharing:add #{email}"
      system "cd #{dir} && heroku sharing:transfer #{email}"
      system "cd #{dir} && heroku sharing:remove #{Settings.secrets["heroku_user"]}"

      body =
"""
Hello,

Your Hubot, #{name} has been built and deployed to Heroku for you.

 -- Hubot Factory Worker
"""

     Pony.mail(:to      => email,
              :from    => "hubot@tombell.org.uk",
              :subject => "Your Hubot is Ready!",
              :body    => body)
    end

    def self.valid_adapters
      [
        "campfire",
        "email",
        "groupme",
        "hipchat",
        "irc",
        "twilio",
        "xmpp"
      ]
    end
  end
end
