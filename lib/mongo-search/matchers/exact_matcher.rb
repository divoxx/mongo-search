module MongoSearch
  module Matchers
    class ExactMatcher
      def initialize(attr, field = nil)
        @attr = @field = attr
        @field = field if field
      end

      def call(params)
        filters = {}
        filters[@field] = params[@attr] if params[@attr] && !params[@attr].empty?
        filters
      end
    end
  end
end
