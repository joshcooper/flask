# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flask/version"

Gem::Specification.new do |spec|
  spec.name          = "flask"
  spec.version       = Flask::VERSION
  spec.authors       = ["Josh Cooper"]
  spec.email         = ["josh@puppet.com"]

  spec.summary       = %q{flask.}
  spec.description   = %q{flask.}
  spec.homepage      = "https://github.com/joshcooper/flask"
  spec.license       = "MIT"
  spec.files         = Dir['exe/*'] +
                       Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bolt"
  spec.add_runtime_dependency "ruby-terraform", "~> 0.50"
  spec.add_runtime_dependency "byebug"
  spec.add_runtime_dependency "rspec"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
#  spec.add_development_dependency "minitest", "~> 5.0"
end
