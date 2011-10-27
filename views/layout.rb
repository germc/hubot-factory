module HubotFactory
  module Views
    class Layout < Mustache
      def title
        @title || "Hubot Factory"
      end
    end
  end
end
