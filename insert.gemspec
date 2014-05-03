# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'insert/version'

Gem::Specification.new do |spec|
  spec.name          = "insert"
  spec.version       = Insert::VERSION
  spec.authors       = ["Seamus Abshere"]
  spec.email         = ["seamus@abshere.net"]
  spec.summary       = %q{Super simple way to insert rows into a database.}
  spec.description   = %q{Super simple way to insert rows into a database. Currently only supports postgres.}
  spec.homepage      = "https://github.com/seamusabshere/insert"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'activerecord'

  spec.add_runtime_dependency 'pg'
  spec.add_runtime_dependency 'murmurhash3'
end
