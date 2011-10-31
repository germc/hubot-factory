module HubotFactory
  module Email
    def self.send_notification(email, name, adapter, adapter_vars)
      body = render_email(name, adapter, adapter_vars)
      send_email(email, body)
    end

    def self.render_email(name, adapter, adapter_vars)
      path = File.expand_path("../../../templates/email.mustache", __FILE__)
      tmpl = IO.read(path)
      body = Mustache.render(tmpl, :name         => name,
                                   :adapter      => adapter,
                                   :adapter_vars => adapter_vars)
    end

    def self.send_email(email, body)
      Pony.mail(:to      => email,
                :subject => "Your Hubot is ready",
                :body    => body,
                :headers => { "Content-Type" => "text/html" });
    end
  end
end
