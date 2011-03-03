require 'rubygems'
require 'bundler'
require './lib/zoopla'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "zoopla"
  gem.homepage = "http://github.com/shadchnev/zoopla"
  gem.license = "MIT"
  gem.summary = %Q{Access zoopla.co.uk API from ruby scripts}
  gem.description = %Q{Access zoopla.co.uk API from ruby scripts. Fetch sales and rental properties for the UK}
  gem.email = "evgeny.shadchnev@gmail.com"
  gem.authors = ["Evgeny Shadchnev"]
  gem.version = Zoopla::Version::STRING
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = Zoopla::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "zoopla #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
