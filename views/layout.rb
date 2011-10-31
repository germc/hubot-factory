module HubotFactory
  module Views
    class Layout < Mustache
      def title
        @title || "Build and Deploy Your Own Hubot - Hubot Factory"
      end
    end
  end
end
