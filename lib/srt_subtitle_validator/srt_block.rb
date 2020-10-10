module SrtSubtitleValidator
  class SrtBlock
    attr_accessor :dialog_number, :dialog_time, :dialog_text

    # @overload new(text)
    #   Block of subtitle content, it will be split automatically
    #   @param args [String] describe key param
    # @overload new(text)
    #   @param dialog_number [String] number of sequence
    #   @param dialog_time [String] time of sequence
    #   @param dialog_text [String] subtitle text itself
    def initialize(*args)
      case args.count
      when 1
        blok = args[0].split("\n")
        @dialog_number = blok.shift.to_i
        @dialog_time = blok.shift
        @dialog_text = blok.join("\n")
      when 3
        @dialog_number = args.shift.to_i
        @dialog_time = args.shift
        @dialog_text = args.shift.strip
      else
        raise ArgumentError
      end
    end

    # @return [String] subtitle sequence block
    def to_s
      [@dialog_number, @dialog_time, @dialog_text].join("\n") + "\n\n"
    end
  end
end