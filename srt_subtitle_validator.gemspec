# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'srt_subtitle_validator/version'

Gem::Specification.new do |spec|
  spec.name          = 'srt_subtitle_validator'
  spec.version       = SrtSubtitleValidator::VERSION
  spec.authors       = ['Lukáš Pokorný']
  spec.email         = ['luk4s.pokorny@gmail.com']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'localhost'
  end

  spec.summary       = 'SRT subtitle file checker, validator'
  spec.description   = 'For check encoding and srt subtitle number sequence'
  spec.homepage      = 'https://github.com/luk4s/srt-subtitle-validator'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'thor'
end
