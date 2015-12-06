require 'srt_subtitle_validator/srt_file'
module SrtSubtitleValidator
  class Validator

    attr_reader :srt

    def initialize(file_path, encoding = nil)
      @path = File.absolute_path(file_path)
      @file_name = File.basename(@path)
      parse_srt(File.read(@path, :encoding => (encoding || 'utf-8')))
    end

    def valid?
      @srt.valid?
    end

    def convert_srt(skip_backup = false)
      backup_original_file unless !!skip_backup
      @new_srt = Tempfile.new([@file_name.gsub('.srt', ''), '.srt'])
      recalculate_number_sequence

      puts ' > Save as UTF-8 encoded file...'
      FileUtils.cp(@new_srt.path, @path)
      @new_srt.close
      @new_srt.unlink
    end

    def recalculate_number_sequence
      return if @srt.blocks.count == @srt.length
      puts ' > Create new number sequence...'
      @srt.blocks.each_with_index do |block, index|
        number = index + 1
        n = SrtSubtitleValidator::SrtFile::SrtBlock.new(number, block.dialog_time, block.dialog_text)
        @new_srt.write(n.to_s)
      end
    end

    def missing_numbers
      @missing_numbers ||= (Array(1..@srt.length) - @srt.blocks.map(&:dialog_number))
    end

    private

    def backup_original_file
      puts ' > Create backup...'
      backup_suffix = 1
      possible_backup_file = @path + '.' + backup_suffix.to_s
      while File.exist?(possible_backup_file)
        possible_backup_file = @path + '.' + (backup_suffix + 1).to_s
        raise StandardError if backup_suffix >= 99
      end
      FileUtils.cp(@path, possible_backup_file)
    end

    def parse_srt(raw, with_fallback = true)
      begin
        @srt = SrtSubtitleValidator::SrtFile.new(raw)
      rescue ArgumentError => e
        if e.to_s == 'invalid byte sequence in UTF-8' && with_fallback
          parse_srt(raw.force_encoding('cp1250'), false)
          @srt.errors << 'Invalid encoding'
        end
      end

    end

  end

end
