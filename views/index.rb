module HubotFactory
  module Views
    class Index < Layout
      # note: could probably change this into an array of hashes
      #   - script name
      #   - script desc
      def hubot_scripts
        [
          "adult",
          "auto-stache",
          "bing",
          "dnsimple",
          "eight-ball",
          "fogbugz",
          "gemwhois",
          "giftv",
          "github-issues",
          "googlee",
          "haters",
          "hideyakids",
          "keep-alive",
          "lastfm_np",
          "likeaboss",
          "lolz",
          "meme_generator",
          "pivotal",
          "polite",
          "redis-brain",
          "remind",
          "rubygems",
          "sendgrid",
          "shipit",
          "speak",
          "spotify",
          "stocks",
          "sudo",
          "teamcity",
          "train",
          "travis",
          "tweet",
          "vanity",
          "weather",
          "wolfram"
        ]
      end
    end
  end
end
