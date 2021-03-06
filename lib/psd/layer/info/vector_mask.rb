require 'psd/layer_info'

class PSD
  class VectorMask < LayerInfo
    def self.should_parse?(key)
      ['vmsk', 'vsms'].include?(key)
    end

    attr_reader :invert, :not_link, :disable, :paths

    def parse
      version = @file.read_int
      tag = @file.read_int

      @invert = tag & 0x01
      @not_link = (tag & (0x01 << 1)) > 0
      @disable = (tag & (0x01 << 2)) > 0

      # I haven't figured out yet why this is 10 and not 8.
      num_records = (@length - 10) / 26
      @paths = []
      num_records.times do
        @paths << PathRecord.new(@file)
      end
    end
  end
end
