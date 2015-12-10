require 'srt_subtitle_validator'
require 'thor'
require 'logger'
if ['--version', '-v'].include?(ARGV.first)
  puts "Srt Subtitle Validator #{SrtSubtitleValidator::VERSION}"
  exit(0)
end
module SrtSubtitleValidator
  class Cli < Thor

    class_option :version, type: :boolean, aliases: '-v', group: :main,
                 desc: 'Show version number and quit'
    method_option :file, :aliases => '-i', :required => true, :type => :string, :desc => 'Path to SRT file'
    method_option :without_backup, :default => false, :type => :boolean, :desc => 'Skip backuping original SRT file'
    method_option :auto_fix, :default => false, :type => :boolean, :desc => 'Always convert invalid file'
    desc 'check', 'Check SRT file. '
    def check
      validator = SrtSubtitleValidator::Validator.new(options[:file])

      if validator.valid?
        say 'SRT file looks like OK :)', :green
      else
        say 'SRT is invalid, with following errors: ', :red, true
        validator.srt.errors.each {|e| say "* #{e}"}
        if options[:auto_fix] || yes?('Try to convert ?')
          validator.convert_srt(options[:without_backup])
        end
      end
    end


    method_option :without_backup, :default => false, :type => :boolean, :desc => 'Skip backuping original SRT file'
    def autofix(files)
      Array(files).each do |file|
        validator = SrtSubtitleValidator::Validator.new(file)
        if validator.valid?
          say 'SRT file looks like OK :)', :green
        else
          validator.convert_srt(options[:without_backup])
        end
      end
    end


    default_task :check
  end
end
SrtSubtitleValidator::Cli.start
