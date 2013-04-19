module MongoSearch
  module Matchers
    class OrMatcher
      def initialize(matchers)
        @matchers = []
        matchers.each do |m|
          @matchers << m[:match].new(m[:attr]) unless m[:field]
          @matchers << m[:match].new(m[:attr], m[:field]) if m[:field]
        end
      end

      def call(params)
        mongo_matchers = @matchers.map do |matcher|
          expression = matcher.call(params)
          nil if expression.empty?
          expression if !expression.empty?
        end.compact

        return { :$or => mongo_matchers } if !mongo_matchers.empty?
        return {}
      end
    end
  end
end
