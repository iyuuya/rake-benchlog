# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake/benchlog/version'

Gem::Specification.new do |spec|
  spec.name          = "rake-benchlog"
  spec.version       = Rake::Benchlog::VERSION
  spec.authors       = ["iyuuya"]
  spec.email         = ["i.yuuya@gmail.com"]
  spec.summary       = %q{Benchmarks your rake tasks and automatically logging.}
  spec.description   = %q{Benchmark and logging rake tasks.}
  spec.homepage      = "https://github.com/iyuuya/rake-benchlog"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", "~> 10.0"
  spec.add_development_dependency "bundler", "~> 1.7"
end
