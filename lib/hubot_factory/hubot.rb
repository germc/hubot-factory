module HubotFactory
  module Hubot
    def self.create(hubot_bin,  name)
      system "#{hubot_bin}", "-c", ".", "-n", "#{name}"
    end

    def self.procfile(name, adapter, process)
      system "sed", "-i", "s/-n hubot/-n #{name}/", "Procfile"
      system "sed", "-i", "s/-a campfire/-a #{adapter}/", "Procfile"

      unless process == "app"
        system "sed", "-i", "s/app:/#{process}:/", "Procfile"
      end
    end
  end
end
