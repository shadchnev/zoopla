# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zoopla/version"

Gem::Specification.new do |s|
  s.name        = "zoopla"
  s.version     = Zoopla::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Evgeny Shadchnev"]
  s.email       = ["evgeny.shadchnev@gmail.com"]
  s.homepage    = "http://github.com/shadchnev/zoopla"
  s.summary     = %q{Access zoopla.co.uk API from ruby scripts}
  s.description = %q{Access zoopla.co.uk API from ruby scripts. Fetch sales and rental properties for the UK}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.licenses = ["MIT"]
  s.rubygems_version = %q{1.3.7}

  s.add_dependency 'hashie', '~> 3.4'
  s.add_dependency 'curb', '~> 0.8'
  s.add_dependency 'json', '~> 1.8'

  s.add_development_dependency 'mocha', '~> 1.0'
  s.add_development_dependency 'test-unit', '~> 3.0'
end
