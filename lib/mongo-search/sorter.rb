module MongoSearch
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
