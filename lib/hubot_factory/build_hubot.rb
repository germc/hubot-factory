require "tmpdir"

module HubotFactory
  class BuildHubot
    @queue = :build_hubot

    def self.perform(email, name, adapter, scripts)

      adapter = "shell" unless valid_adapters.include? adapter

      dir = Dir.mktmpdir "#{name}-"

      system "#{Settings.secrets["hubot_bin"]} -c #{dir} -n #{name}"
      system "sed", "-i", "s/-n Hubot/-n #{name}/", "#{dir}/Procfile"
      system "sed", "-i", "s/-a campfire/-a #{adapter}/", "#{dir}/Procfile"
      system "cd #{dir} && git init && git add . && git commit -m 'Initial commit'"
      system "cd #{dir} && heroku create -s cedar"
      system "cd #{dir} && git push heroku master"
      system "cd #{dir} && heroku ps:scale app=1"
      system "cd #{dir} && heroku sharing:add #{email}"
      system "cd #{dir} && heroku sharing:transfer #{email}"

      body =
"""
Hello,

Your Hubot, #{name} has been built and deployed to Heroku for you.
You will still need to configure some Heroku config variables to
get it running. We hope to automate this part in the future for
you.

Note: You should remove #{Settings.secrets["email_user"} from the
Heroku application now that it has been transferred to your account.

 -- Hubot Factory Worker
"""

      smtp_settings = {
        :address              => Settings.secrets["email_host"],
        :port                 => Settings.secrets["email_port"],
        :enable_starttls_auto => true,
        :user_name            => Settings.secrets["email_user"],
        :password             => Settings.secrets["email_pass"],
        :authentication       => :plain,
        :domain               => "localhost.localdomain"
      }

      Pony.mail(:to          => email,
                :subject     => "Your Hubot is Ready!",
                :body        => body,
                :via_options => smtp_settings)
    end

    def self.valid_adapters
      [ "campfire", "email", "groupme", "hipchat", "irc", "twilio", "xmpp" ]
    end
  end
end
