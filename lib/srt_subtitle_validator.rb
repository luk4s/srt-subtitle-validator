require 'srt_subtitle_validator/version'
# require 'srt_subtitle_validator/srt_file'
require 'srt_subtitle_validator/validator'

module SrtSubtitleValidator
  # Your code goes here...

end

class String
  def blank?
    to_s == ''
  end
end

class NilClass
  def blank?
    true
  end
end

class Array
  def blank?
    empty?
  end
end
