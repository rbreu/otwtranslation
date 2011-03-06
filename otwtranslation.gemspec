# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "otwtranslation/version"

Gem::Specification.new do |s|
  s.name        = "otwtranslation"
  s.version     = Otwtranslation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Organization for Transformative Works"]
  s.email       = ["rebecca@rbreu.de"]
  s.homepage    = ""
  s.summary     = %q{Translation engine for otwarchive}
  s.description = %q{Translation engine for otwarchive}

  s.rubyforge_project = "otwtranslation"

  s.files         = `git ls-files -- {app,lib,config}/*`.split("\n")
  s.files        += ["Rakefile", "Gemfile", "README.rst"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.0.5"
  s.add_dependency "rails_helpers_fix"

  s.add_development_dependency "rspec-rails", "~> 2.1.0"
  s.add_development_dependency "cucumber-rails", "~> 0.3.2"
  s.add_development_dependency "capybara", "~> 0.4.1.2"
end

