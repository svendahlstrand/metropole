# encoding: utf-8
require File.expand_path('../lib/metropole/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sven Dahlstrand"]
  gem.email         = ["sven.dahlstrand@gmail.com"]
  gem.description   = %q{Metrics}
  gem.summary       = %q{Metrics}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "metropole"
  gem.require_paths = ["lib"]
  gem.version       = Metropole::VERSION

  gem.add_runtime_dependency 'flay', '~> 2.0.0.b1'
  gem.add_runtime_dependency 'flog', '~> 3.0.0.b2'
  gem.add_runtime_dependency 'coderay'
end
