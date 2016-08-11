require 'srt_subtitle_validator/srt_file'
class InvalidFile < ArgumentError; end
module SrtSubtitleValidator
  class Validator

    require 'logger'
    require 'tempfile'
  
    attr_reader :srt, :path, :file_name

    def initialize(file_path, encoding = nil, logger = nil)
      @logger = logger || Logger.new(STDOUT)
      @path = File.absolute_path(file_path).strip
      raise InvalidFile unless File.extname(@path) == '.srt'
      @file_name = File.basename(@path)
      parse_srt(File.read(@path, :encoding => (encoding || Encoding::UTF_8)))
    end

    def valid?
      @srt.valid?
    end

    def convert_srt(output, skip_backup = false)
      skip_backup ||= output_file(output) != @path
      backup_original_file unless !!skip_backup
      @new_srt = Tempfile.new([@file_name.gsub('.srt', ''), '.srt'])
      recalculate_number_sequence

      @logger.info ' > Save as UTF-8 encoded file...'
      @new_srt.flush
      FileUtils.copy(@new_srt.path, output_file(output))
      @new_srt.close
      @new_srt.unlink
    end

    def missing_numbers
      @missing_numbers ||= (Array(1..@srt.length) - @srt.blocks.map(&:dialog_number))
    end

    private

    def recalculate_number_sequence
      @logger.info ' > Create new number sequence...'
      @srt.blocks.each_with_index do |block, index|
        number = index + 1
        n = SrtSubtitleValidator::SrtFile::SrtBlock.new(number, block.dialog_time, block.dialog_text)
        @new_srt.write(n.to_s)
      end
    end

    def output_file(output = nil)
      if output.to_s.empty?
        @path
      else
        if File.directory?(output)
          File.join(output, @file_name)
        else
          output
        end
      end
    end


    def backup_original_file
      @logger.info ' > Create backup...'
      backup_suffix = 1
      possible_backup_file = @path + '.' + backup_suffix.to_s
      while File.exist?(possible_backup_file)
        possible_backup_file = @path + '.' + (backup_suffix += 1).to_s
        raise StandardError if backup_suffix >= 66
      end
      FileUtils.cp(@path, possible_backup_file)
    end

    def parse_srt(raw, with_fallback = true)
      begin
        @srt = SrtSubtitleValidator::SrtFile.new(raw)
      rescue ArgumentError => e
        if e.to_s == 'invalid byte sequence in UTF-8' && with_fallback
          parse_srt(raw.force_encoding(Encoding::CP1250), false)
          @srt.errors << 'Invalid encoding'
        end
      end

    end

  end

end
