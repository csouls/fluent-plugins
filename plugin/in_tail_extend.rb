module Fluent

  require 'fluent/plugin/in_tail'

  class TailInputExtend < TailInput
    Plugin.register_input('tail_ex', self)

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
        next if !record.has_key?(key) || record[key].empty?
        begin
          value = Integer record[key]
        rescue ArgumentError => e
          puts e; next
        end
        record[key] = value
      }
      @float.each {|key|
        next if !record.has_key?(key) || record[key].empty?
        begin
          value = Float record[key]
        rescue ArgumentError => e
          puts e; next
        end
        record[key] = value
      }
      return time, record
    end
  end
end
