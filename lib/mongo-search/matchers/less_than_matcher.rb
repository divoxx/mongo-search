module MongoSearch
  module Matchers
    class LessThanMatcher
      def initialize(attr, opts = nil)
        opts ||= {}
        @attr     = attr
        @field    = opts[:field] || attr
        @operator = opts[:equal] ? :$lte : :$lt
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
