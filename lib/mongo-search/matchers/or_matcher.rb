module MongoSearch
  module Matchers
    class OrMatcher
      def initialize(matchers)
        @matchers = matchers
      end

      def call(params)

        puts @matchers.inspect
        mongo_matchers = @matchers.map do |matcher|
          matcher.call(params)
        end

        { :$or => mongo_matchers }
      end
    end
  end
end
