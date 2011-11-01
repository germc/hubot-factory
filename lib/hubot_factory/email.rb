module HubotFactory
  module Email
    # Send a rendered email notification to the user that their Hubot has been
    # built and deployed to Heroku.
    #
    # email        - A String of the email of the Heroku account.
    # name         - A String of the robot name.
    # adapter      - A String of the robot adapter used.
    # adapter_vars - An Array of Hashes of environment variables set.
    #
    # Returns nothing.
    def self.send_notification(email, name, adapter, adapter_vars)
      body = render_email(name, adapter, adapter_vars)
      send_email(email, body)
    end

    # Render the mustache template of the email body.
    #
    # name         - A String of the robot name.
    # adapter      - A String of the robot adapter used.
    # adapter_vars - An Array of Hashes of environment variables set.
    #
    # Returns nothing.
    def self.render_email(name, adapter, adapter_vars)
      path = File.expand_path("../../../templates/email.mustache", __FILE__)
      tmpl = IO.read(path)
      body = Mustache.render(tmpl, :name         => name,
                                   :adapter      => adapter,
                                   :adapter_vars => adapter_vars)
    end

    # Send the rendered email to the user.
    #
    # email - A String of the email of the Heroku account.
    # body  - A String of the rendered email body.
    #
    # Returns nothing.
    def self.send_email(email, body)
      Pony.mail(:to      => email,
                :from    => Settings.secrets["email_from"],
                :subject => "Your Hubot is ready",
                :body    => body,
                :headers => { "Content-Type" => "text/html" });
    end
  end
end
