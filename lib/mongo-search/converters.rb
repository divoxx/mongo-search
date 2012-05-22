module MongoSearch
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
end
