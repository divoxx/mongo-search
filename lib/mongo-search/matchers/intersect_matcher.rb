module MongoSearch
  module Matchers
    class IntersectMatcher
      def initialize(attr)
        @attr = attr
      end

      def call(params)
        filters = {}

        if params[@attr] && !params[@attr].empty?
          value = params[@attr]
          filters[@attr] = {:$all => Converters[:array].call(value)}
        end

        filters
      end
    end
  end
end
