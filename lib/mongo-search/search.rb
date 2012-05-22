class Search
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

private
  class Builder
    def initialize(search)
      @search = search
    end

    def match(attr)
      @search << PartialMatcher.new(attr)
    end

    def exact(attr)
      @search << ExactMatcher.new(attr)
    end

    def intersect(attr)
      @search << IntersectMatcher.new(attr)
    end

    def greater_than(attr, opts = nil)
      @search << GreaterThanMatcher.new(attr, opts)
    end

    def sort_with(attr, opts = nil)
      @search.sorter = Sorter.new(attr, opts)
    end
  end

  # Hash of proc converter objects, defaults to identity func
  Converters = Hash.new { |h,k| lambda { |i| i } }

  Converters[:time] = lambda do |v|
    if v.is_a?(Time)
      v
    else
      Time.parse(v.to_s)
    end
  end

  Converters[:array] = lambda do |v|
    if v.is_a?(String)
      v.split(/\s*,\s*/)
    else
      Array(v)
    end
  end

  class PartialMatcher
    def initialize(attr)
      @attr = attr
    end

    def call(params)
      filters = {}
      filters[@attr] = /#{Regexp.escape(params[@attr])}/i if params[@attr]
      filters
    end
  end

  class ExactMatcher
    def initialize(attr)
      @attr = attr
    end

    def call(params)
      filters = {}
      filters[@attr] = params[@attr] if params[@attr]
      filters
    end
  end

  class IntersectMatcher
    def initialize(attr)
      @attr = attr
    end

    def call(params)
      filters = {}

      if params[@attr]
        value = params[@attr]
        filters[@attr] = {:$all => Converters[:array].call(value)}
      end

      filters
    end
  end

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

  class Sorter
    def initialize(attr, opts = nil)
      @attr, @opts = attr, opts || {}
    end

    def call(params)
      sort = []

      if order_by = params[@attr] || @opts[:default]
        order_by.split(/\s*,\s*/).each do |attr_order|
          if attr_order =~ /([^\s]+)(?:\s*(asc|desc)?)$/
            attr_name, dir = $1, ($2 || :asc)
            sort << [:"#{attr_name}_ordenacao", :"#{dir}"]
            sort << [:"#{attr_name}", :"#{dir}"]
          else
            raise ArgumentError, "invalid sorting parameters: #{order_by}"
          end
        end
      end

      sort
    end
  end
end
