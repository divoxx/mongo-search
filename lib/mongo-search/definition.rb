module MongoSearch
  class Definition
    def initialize
      @filters = []
      @sorter  = nil
      yield Builder.new(self) if block_given?
    end

    def <<(filter)
      @filters << filter
    end

    def sorter=(sorter)
      @sorter = sorter
    end

    def criteria_for(params)
      conditions = {}

      @filters.each do |filter|
        conditions.merge! filter.call(params)
      end

      sort = @sorter ? @sorter.call(params) : []

      [conditions, sort]
    end
  end
end
