require 'srt_subtitle_validator'
require 'thor'
require 'logger'

if ['--version', '-v'].include?(ARGV.first)
  puts "Srt Subtitle Validator #{SrtSubtitleValidator::VERSION}"
  exit(0)
end
module SrtSubtitleValidator
  class Cli < Thor

    def self.srt_default_options
      method_option :without_backup, :default => false, :type => :boolean, :desc => 'Skip backuping original SRT file'
      method_option :output, :aliases => '-o', :default => nil, :type => :string, :desc => 'Output directory (file)'
      method_option :encoding, :aliases => '-e', :default => Encoding::CP1250, :type => :string, :desc => 'Output directory (file)'
    end

    class_option :version, type: :boolean, aliases: '-v', group: :main,
                 desc: 'Show version number and quit'
    method_option :auto_fix, :default => false, :type => :boolean, :desc => 'Always convert invalid file'
    srt_default_options
    desc 'check', 'Check SRT file. '
    def check(file)
      validator = SrtSubtitleValidator::Validator.new(file)
      if validator.valid?
        say 'SRT file looks like OK :)', :green
      else
        say 'SRT is invalid, with following errors: ', :red, true
        validator.srt.errors.each {|e| say "* #{e}"}
        if options[:auto_fix] || yes?('Try to convert ?')
          validator.convert_srt(options[:output], options[:without_backup])
        end
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
