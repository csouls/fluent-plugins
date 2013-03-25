class TailInputExtend < TailInput
  Fluent::Plugin.register_input('tail_ex', self)

  config_param :int, :string, :default => ""
  config_param :float, :string, :default => ""

  def configure(conf)
    super

    @int = @int.split(',').map {|key| key.strip}
    @float = @float.split(',').map {|key| key.strip}
  end

  def parse_line(line)
    time, record = @parser.parse(line)
    @int.each {|key|
      next unless record.has_key?(key)
      record[key] = cast_value(record, key, :Integer)
    }
    @float.each {|key|
      next unless record.has_key?(key)
      record[key] = cast_value(record, key, :Float)
    }
    return time, record
  end

  def cast_value(record, key, klass)
    return record[key] if record[key].nil? || record[key].empty?
    begin
      return Object.send(klass, record[key])
    rescue ArgumentError => e
      $log.error $!.to_s
      return record[key]
    end
  end
end
