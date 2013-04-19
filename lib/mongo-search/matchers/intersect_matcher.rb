module MongoSearch
  module Matchers
    class IntersectMatcher
      def initialize(attr, field = nil)
        @attr = @field = attr
        @field = field if field
      end

      def call(params)
        filters = {}

        if params[@attr] && !params[@attr].empty?
          value = params[@attr]
          filters[@field] = {:$all => Converters[:array].call(value)}
        end

        filters
      end
    end
  end
end
