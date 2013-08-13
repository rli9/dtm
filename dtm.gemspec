# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dtm/version'

Gem::Specification.new do |spec|
  spec.name          = "dtm"
  spec.version       = Dtm::VERSION
  spec.authors       = ["Ruijia Li"]
  spec.email         = ["ruijia.li@gmail.com"]
  spec.description   = %q{A ruby wrapper for Microsoft DTM (Driver Test Manager) console application wttcl.exe}
  spec.summary       = %q{A ruby wrapper for Microsoft DTM (Driver Test Manager) console application wttcl.exe}
  spec.homepage      = "https://github.com/rli9/dtm"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
end