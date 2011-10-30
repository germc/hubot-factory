require "tmpdir"

module HubotFactory
  class BuildHubot
    @queue = :build_hubot

    # Build and deploy a Hubot to Heroku for a user.
    #
    # Returns nothing.
    def self.perform(email, name, adapter, adapter_vars)
      process = if adapter.downcase == "twilio"
        "web"
      else
        "app"
      end

      create_hubot_dir(name)

      create_hubot(name)

      setup_procfile(name, adapter, process)

      init_git_repository

      create_heroku_app

      config_heroku_app(adapter_vars)

      push_heroku_app


      scale_heroku_app(process)

      transfer_heroku_app(email)

      send_notification_email(email, name, adapter, adapter_vars)
    end

    # Create the temporary directory to store the Hubot being built.
    #
    # name - A String of the robot's name.
    #
    # Returns nothing.
    def self.create_hubot_dir(name)
      dir = Dir.mktmpdir "#{name}-"
      Dir.chdir dir
    end

    # Create the Hubot directory structure and files.
    #
    # name - A String of the robot's name.
    #
    # Returns nothing.
    def self.create_hubot(name)
      system "#{Settings.secrets["hubot_bin"]} -c . -n #{name}"
    end

    # Sets up the Procfile with correct name and adapter.
    #
    # name    - A String of the robot's name.
    # adapter - A String of the adapter.
    #
    # Returns nothing.
    def self.setup_procfile(name, adapter, process)
      system "sed", "-i", "s/-n Hubot/-n #{name}/", "Procfile"
      system "sed", "-i", "s/-a campfire/-a #{adapter}/", "Procfile"
      system "sed", "-i", "s/app:/#{process}:/", "Procfile"
    end

    # Initialise and commit the robot into a git repository.
    #
    # Returns nothing.
    def self.init_git_repository
      system "git init && git add . && git commit -m 'Initial commit'"
    end

    # Create a new Heroku application on the Cedar stack.
    #
    # Returns nothing.
    def self.create_heroku_app
      system "heroku create --stack cedar"
    end

    # Set the environment variables in the Heroku application for the adapter.
    #
    # adapter_variables - An Array of Hashes of environment variables to set.
    # 
    # Returns nothing.
    def self.config_heroku_app(adapter_variables)
      vars = adapter_variables.map { |v| "#{v["var"]}=\"#{v["val"]}\"" }
      system "heroku config:add #{vars.join " "}"
    end

    # Push the git repository up to the Heroku application.
    #
    # Returns nothing.
    def self.push_heroku_app
      system "git push heroku master"
    end

    # Scale the specified process for the Heroku application.
    #
    # process - A String of the process to scale up.
    #
    # Returns nothing.
    def self.scale_heroku_app(process)
      system "heroku ps:scale #{process}=1"
    end

    # Transfer the Heroku application to the user and remove self as a
    # collaborator.
    #
    # email - A String of the email address of the Heroku account to
    #         transfer to.
    #
    # Returns nothing.
    def self.transfer_heroku_app(email)
      system "heroku sharing:add #{email}"
      system "heroku sharing:transfer #{email}"
      system "heroku sharing:remove #{Settings.secrets["heroku_user"]}"
    end

    # Send a notification email to the user when the build and deploy to Heroku
    # is finished.
    #
    # email        - A String of the email of the user to notify.
    # name         - A String of the robot's name.
    # adapter      - A String of the robot adapter.
    # adapter_vars - An Array of Hashes of environment variables.
    #
    # Returns nothing.
    def self.send_notification_email(email, name, adapter, adapter_vars)
      path     = File.expand_path "../../../templates/email.mustache", __FILE__
      template = IO.read(path)
      body     = Mustache.render(template, :name         => name,
                                           :adapter      => adapter,
                                           :adapter_vars => adapter_vars)

      Pony.mail(:to      => email,
                :subject => "Your Hubot is Ready",
                :body    => body,
                :headers => { "Content-Type" => "text/html" })
    end
  end
end
