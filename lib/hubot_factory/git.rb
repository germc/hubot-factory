module HubotFactory
  module Git
    def self.init
      system "git", "init"
    end

    def self.add
      system "git", "add", "."
    end

    def self.commit
      system "git", "commit", "-m", '"Initial commit"'
    end

    def self.push
      system "git", "push", "heroku", "master"
    end
  end
end
