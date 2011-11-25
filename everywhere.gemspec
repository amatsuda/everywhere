# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "everywhere/version"

Gem::Specification.new do |s|
  s.name        = "everywhere"
  s.version     = Everywhere::VERSION
  s.authors     = ["Akira Matsuda"]
  s.email       = ["ronnie@dio.jp"]
  s.homepage    = 'https://github.com/amatsuda/everywhere'
  s.summary     = %q{Hash condition syntax for AR query everywhere!}
  s.description = %q{Hash condition syntax for AR query everywhere!}

  s.rubyforge_project = "everywhere"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
  s.add_runtime_dependency 'activerecord'
end
