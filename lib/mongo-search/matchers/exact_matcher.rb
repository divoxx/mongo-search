module MongoSearch
  module Matchers
    class ExactMatcher
      def initialize(attr)
        @attr = attr
      end

      def call(params)
        filters = {}
        filters[@attr] = params[@attr] if params[@attr]
        filters
      end
    end
  end
end
