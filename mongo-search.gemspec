# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo-search/version"

Gem::Specification.new do |s|
  s.name        = "mongo-search"
  s.version     = Mongo::Search::VERSION
  s.authors     = ["Rodrigo Kochenburger <divoxx@gmail.com>", "Tomas Mattia <tomas.mattia@gmail.com>"]
  s.email       = ["abril_vejasp_dev@thoughtworks.com"]
  s.homepage    = ""
  s.summary     = %q{Easy search for mongodb}

  s.rubyforge_project = "mongo-search"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "debugger"
  # s.add_runtime_dependency "rest-client"
end
