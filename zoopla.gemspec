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

  s.add_dependency(%q<hashie>, ["~> 1.0.0"])
  s.add_dependency(%q<curb>, ["~> 0.7.12"])
  s.add_dependency(%q<json>, ["~> 1.4.3"])

  s.add_development_dependency(%q<mocha>, ["~>  0.9.12"])
end