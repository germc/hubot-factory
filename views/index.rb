module HubotFactory
  module Views
    class Index < Layout
      def hubot_adapters
        [
          { :name => "Campfire" },
          { :name => "Email" },
          { :name => "GroupMe" },
          { :name => "HipChat" },
          { :name => "IRC" },
          { :name => "Twilio" },
          { :name => "XMPP" },
        ]
      end

      def hubot_scripts
        false
      end
    end
  end
end
