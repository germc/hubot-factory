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

      file_path = File.expand_path("../../../templates/email.mustache",
                                   __FILE__)

      template = IO.read(file_path)
      body     = Mustache.render(template, :name         => name,
                                           :adapter      => adapter,
                                           :adapter_vars => adapter_vars)

      Pony.mail(:to      => email,
                :from    => "hubot@tombell.org.uk",
                :subject => "Your Hubot is Ready",
                :body    => body,
                :headers => { "Content-Type" => "text/html" })
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
