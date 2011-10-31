module HubotFactory
  module Git
    # Initialize the current directory as a git repository.
    #
    # Returns nothing.
    def self.init
      system "git init"
    end

    # Add all the files in the current directory to the git repository.
    #
    # Returns nothing.
    def self.add
      system "git add ."
    end

    # Commit the staged changes into the git repository.
    #
    # Returns nothing.
    def self.commit
      system "git commit -m 'Initial commit'"
    end

    # Push the commits to the Heroku remote repository.
    #
    # Returns nothing.
    def self.push
      system "git push heroku master"
    end
  end
end
