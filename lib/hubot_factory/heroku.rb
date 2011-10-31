module HubotFactory
  module Heroku
    def self.create
      system "heroku", "create", "--stack", "cedar"
    end

    def self.config(variables)
      vars = variables.map { |v| "#{v["var"]}=\"#{v["val"]}\"" }
      system "heroku config:add #{vars.join(" ")}"
    end

    def self.scale(process)
      system "heroku", "ps:scale", "#{process}=1"
    end

    def self.transfer(to_email, from_email)
      system "heroku", "sharing:add", "#{to_email}"
      system "heroku", "sharing:transfer", "#{to_email}"
      system "heroku", "sharing:remove", "#{from_email}"
    end
  end
end
