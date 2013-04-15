module MongoSearch
  module Matchers
    class OrMatcher
      def initialize(attr)
        @attr = attr
      end

      def call(params)

        value = params[@attr]

        return {} unless value

        #TODO should be generalized for any field
        {
          :$or => [
            { :titulo => value },
            { :tags => {:$in => [value]} }
          ]
        }
      end
    end
  end
end
