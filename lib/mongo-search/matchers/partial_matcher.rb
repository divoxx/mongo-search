module MongoSearch
  module Matchers
    class PartialMatcher
      def initialize(attr, field = nil)
        @attr = @field = attr
        @field = field if field
      end

      def call(params)
        filters = {}
        filters[@field] = /#{Regexp.escape(params[@attr])}/i if params[@attr] && !params[@attr].empty?
        filters
      end
    end
  end
end
