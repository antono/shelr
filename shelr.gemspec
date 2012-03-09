# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shelr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Antono Vasiljev", "Pete Clark"]
  gem.email         = "self@antono.info"
  gem.description   = "Screencast utility for unix shell junkies"
  gem.summary       = "Screencasts for Shell Ninjas"
  gem.homepage      = "http://shelr.tv/"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.name          = "shelr"
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = Shelr::VERSION
  gem.license       = "GPLv3"
end
