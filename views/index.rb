module HubotFactory
  module Views
    class Index < Layout
      def hubot_adapters
        Adapters.adapters
      end

      def hubot_scripts
        false
      end
    end
  end
end
