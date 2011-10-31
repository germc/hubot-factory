module HubotFactory
  module Hubot
    # Create a new Hubot with the specified name.
    #
    # hubot_bin - A String of the path to the Hubot binary.
    # name      - A String of the robot name.
    #
    # Returns nothing.
    def self.create(hubot_bin,  name)
      system "#{hubot_bin} -c . -n #{name}"
    end

    # Configure the Procfile with the specified name, adapter and process type.
    #
    # name    - A String of the name of the robot.
    # adapter - A String of the adapter for the robot.
    # process - A String of the process type.
    #
    # Returns nothing.
    def self.procfile(name, adapter, process)
      system "sed", "-i", "s/-n Hubot/-n #{name}/", "Procfile"
      system "sed", "-i", "s/-a campfire/-a #{adapter}/", "Procfile"
      system "sed", "-i", "s/app:/#{process}:/", "Procfile"
    end
  end
end
