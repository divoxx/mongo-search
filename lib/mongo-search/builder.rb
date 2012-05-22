module MongoSearch
  class Builder
    def initialize(search)
      @search = search
    end

    def match(attr)
      @search << Matchers::PartialMatcher.new(attr)
    end

    def exact(attr)
      @search << Matchers::ExactMatcher.new(attr)
    end

    def intersect(attr)
      @search << Matchers::IntersectMatcher.new(attr)
    end

    def greater_than(attr, opts = nil)
      @search << Matchers::GreaterThanMatcher.new(attr, opts)
    end

    def less_than(attr, opts = nil)
      @search << Matchers::LessThanMatcher.new(attr, opts)
    end

    def sort_with(attr, opts = nil)
      @search.sorter = Sorter.new(attr, opts)
    end
  end
end
