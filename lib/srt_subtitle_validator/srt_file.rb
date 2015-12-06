module SrtSubtitleValidator
  class SrtFile
    attr_reader :blocks, :length
    attr_accessor :errors
    def initialize(source)
      @errors = Array.new
      x = source.dup.encode('utf-8').gsub(/\r/, '')
      @srt_dialog_blocks = Hash.new
      @blocks = x.split(/^\r?\n/m).map { |n| i = SrtBlock.new(n); @srt_dialog_blocks[i.dialog_number] = i; i }
      @length = !@blocks.empty? && @blocks.last.dialog_number || 0
      @errors << 'File is zero size' if @length.zero?
    end

    def valid?
      unless @blocks.count == @length
        @errors << 'Numbers sequence is corrupted'
      end
      @errors.empty?
    end

    class SrtBlock
      attr_accessor :dialog_number, :dialog_time, :dialog_text
      def initialize(*args)
        case args.count
          when 1
            blok = args[0].split("\n")
            @dialog_number = blok.shift.to_i
            @dialog_time = blok.shift
            @dialog_text = blok.join("\n")
          when 3
            @dialog_number, @dialog_time, @dialog_text = args
          else
            raise ArgumentError
        end
      end

      def to_s
        [@dialog_number, @dialog_time, @dialog_text].join("\n") + "\n\n"
      end
    end
  end
end
