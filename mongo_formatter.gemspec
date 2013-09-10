# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongo_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "mongo_formatter"
  spec.version       = MongoFormatter::VERSION
  spec.authors       = ["Piotrek Dubiel"]
  spec.email         = ["piotr.dubiel@polidea.com"]
  spec.description   = %q{Cucumber formatter pushing test results to MongoDB}
  spec.summary       = %q{Cucumber formatter pushing test results to MongoDB}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongo"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
