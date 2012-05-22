module MongoSearch
  module Matchers
    class GreaterThanMatcher
      def initialize(attr, opts = nil)
        opts ||= {}
        @attr     = attr
        @field    = opts[:field] || attr
        @operator = opts[:equal] ? :$gte : :$gt
        @conv     = Converters[opts[:type]]
      end

      def call(params)
        filters = {}
        filters[@field] = {@operator => @conv.call(params[@attr])} if params[@attr] && !params[@attr].empty?
        filters
      end
    end
  end
end
