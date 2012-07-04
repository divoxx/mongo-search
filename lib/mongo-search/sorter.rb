module MongoSearch
  class Sorter
    def initialize(attr, opts = nil)
      @attr, @opts = attr, opts || {}
      @mappings    = @opts[:mappings] || {}
    end

    def call(params)
      sort = []

      if order_by = params[@attr] || @opts[:default]
        order_by.split(/\s*,\s*/).each do |attr_order|
          if attr_order =~ /([^\s]+)(?:\s*(asc|desc)?)$/
            attr_name, dir = $1.to_sym, ($2 || :asc).to_sym
            attr_name = @mappings[attr_name] if @mappings[attr_name]
            sort << [attr_name, dir]
          else
            raise ArgumentError, "invalid sorting parameters: #{order_by}"
          end
        end
      end

      sort
    end
  end
end
