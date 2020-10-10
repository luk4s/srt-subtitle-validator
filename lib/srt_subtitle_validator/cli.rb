require 'srt_subtitle_validator'
require 'thor'
require 'logger'

if %w(--version -v).include?(ARGV.first)
  puts "Srt Subtitle Validator #{SrtSubtitleValidator::VERSION}"
  exit(0)
end
module SrtSubtitleValidator
  class Cli < Thor

    class_option :version, type: :boolean, aliases: '-v', group: :main,
                 desc: 'Show version number and quit'

    def self.srt_default_options
      method_option :without_backup, default: false, type: :boolean, desc: 'Skip backuping original SRT file'
      method_option :output, aliases: '-o', default: nil, type: :string, desc: 'Output directory (file)'
      method_option :encoding, aliases: '-e', default: "cp1250", type: :string, desc: 'Output directory (file)'
    end

    srt_default_options
    desc 'check', 'Check SRT file. '
    def check(*files)
      files_to_convert = Array.new
      Array(files).each do |file|
        validator = SrtSubtitleValidator::Validator.new(file)
        say("\n == #{validator.file_name} -> ")
        if validator.valid?
          say 'SRT file is valid', :green
        else
          say 'SRT file is invalid, with following errors: ', :red, true
          validator.srt.errors.each { |e| say "* #{e}" }
          files_to_convert << validator
        end
      end
      if files_to_convert.any? && yes?("Try to convert  #{files_to_convert.length} files ?")
        files_to_convert.each { |f| f.convert_srt(options[:output], options[:without_backup]) }
      end

    end

    srt_default_options
    desc 'convert', 'Check files and fix them if needed'

    def convert(*files)
      Array(files).each do |file|
        validator = SrtSubtitleValidator::Validator.new(file)
        unless validator.valid?
          validator.convert_srt(options[:output], options[:without_backup])
        end
      end
    end

  end
end
SrtSubtitleValidator::Cli.start
