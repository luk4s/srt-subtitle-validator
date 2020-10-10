# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'srt_subtitle_validator/version'

Gem::Specification.new do |spec|
  spec.name          = 'srt_subtitle_validator'
  spec.version       = SrtSubtitleValidator::VERSION
  spec.authors       = ['Lukáš Pokorný']
  spec.email         = ['luk4s.pokorny@gmail.com']

  spec.summary       = 'SRT subtitle file checker, validator'
  spec.description   = 'For check encoding and srt subtitle number sequence'
  spec.homepage      = 'https://github.com/luk4s/srt-subtitle-validator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.test_files = Dir.glob('spec/**/*')
  spec.required_rubygems_version = '>= 2.6.3'


  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.9'

  spec.add_runtime_dependency 'thor', '~> 1.0'
end
