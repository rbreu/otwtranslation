# -*- coding: utf-8 -*-
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

  s.files         = `git ls-files -- {app,lib,config,db,public}/*`.split("\n")
  s.files        += ["Rakefile", "Gemfile", "README.rst"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.0.5"
  s.add_dependency "rails_helpers_fix"
  s.add_dependency "jquery-rails"
  s.add_dependency "sanitize"
  s.add_dependency "resque", ">=1.14.0"
  s.add_dependency "resque_mailer"
  s.add_dependency "will_paginate"
  s.add_dependency "valium"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "webrat"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "pickle"
  s.add_development_dependency "escape_utils"
end

