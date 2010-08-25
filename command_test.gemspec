# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'command_test/version'

Gem::Specification.new do |s|
  s.name        = 'command_test'
  s.date        = Date.today.strftime('%Y-%m-%d')
  s.version     = CommandTest::VERSION.join('.')
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["George Ogata"]
  s.email       = ["george.ogata@gmail.com"]
  s.homepage    = "http://github.com/oggy/command_test"
  s.summary     = "Test your ruby programs run commands exactly the way you expect."

  s.required_rubygems_version = ">= 1.3.6"
  s.add_development_dependency "rspec", "1.3.0"
  s.add_development_dependency "cucumber", "0.8.5"
  s.files = Dir["lib/**/*"] + %w(CHANGELOG LICENSE README.markdown Rakefile)
  s.test_files = Dir["features/**/*", "spec/**/*"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.require_path = 'lib'
  s.specification_version = 3
  s.rdoc_options = ["--charset=UTF-8"]
end
