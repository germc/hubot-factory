module HubotFactory
  module Heroku
    # Create a new Heroku application on the cedar stack.
    #
    # Returns nothing.
    def self.create
      system "heroku create --stack cedar"
    end

    # Set the Heroku config variables.
    #
    # variables - An Array of Hashes of the config variables to set.
    #
    # Returns nothing.
    def self.config(variables)
      vars = variables.map { |v| "#{v["var"]}=\"#{v["val"]}\"" }
      system "heroku config:add #{vars.join(" ")}"
    end

    # Scale the specified process type to 1.
    #
    # process - A String of the process type.
    #
    # Returns nothing.
    def self.scale(process)
      system "heroku ps:scale #{process}=1"
    end

    # Transfer the Heroku application to the user and remove self as a
    # collaborator.
    #
    # to_email   - A String of the email to transfer to the application to.
    # from_email - A String of the email to remove as a collaborator.
    #
    # Returns nothing.
    def self.transfer(to_email, from_email)
      system "heroku sharing:add #{to_email}"
      system "heroku sharing:transfer #{to_email}"
      system "heroku sharing:remove #{from_email}"
    end
  end
end
