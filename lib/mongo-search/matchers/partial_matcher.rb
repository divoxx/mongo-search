module MongoSearch
  module Matchers
    class PartialMatcher
      def initialize(attr)
        @attr = attr
      end

      def call(params)
        filters = {}
        filters[@attr] = /#{Regexp.escape(params[@attr])}/i if params[@attr] && !params[@attr].empty?
        filters
      end
    end
  end
end
