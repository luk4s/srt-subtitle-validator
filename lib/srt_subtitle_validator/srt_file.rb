require 'logger'
require 'srt_subtitle_validator/srt_block'

module SrtSubtitleValidator
  class SrtFile
    attr_reader :blocks, :length
    attr_accessor :errors

    # @param [String] source content of SRT file
    # @param [Logger] logger object, optionally - by default log to STDOUT
    def initialize(source, logger = nil)
      @logger = logger || Logger.new(STDOUT)
      @errors = []
      @srt_dialog_blocks = {}
      @source = source.dup.encode(Encoding::UTF_8).gsub(/\r/, '')
    end

    def valid?
      @blocks = @source.split(/^\r?\n+/m).map do |n|
        i = SrtBlock.new(n)
        @srt_dialog_blocks[i.dialog_number] = i
        i
      end
      @length = !@blocks.empty? && @blocks.last.dialog_number || 0
      @errors << 'File is zero size' if @length.zero?
      @errors << 'Numbers sequence is corrupted' unless @blocks.count == @length
      @errors.empty?
    end

    def inspect
      "<SrtSubtitleValidator::SrtFile ...>"
    end


  end
end
