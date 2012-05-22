module MongoSearch
  module Matchers
    class GreaterThanMatcher
      def initialize(attr, opts = nil)
        opts ||= {}
        @attr  = attr
        @field = opts[:field] || attr
        @conv  = Converters[opts[:type]]
      end

      def call(params)
        filters = {}
        filters[@field] = {:$gte => @conv.call(params[@attr])} if params[@attr]
        filters
      end
    end
  end
end
