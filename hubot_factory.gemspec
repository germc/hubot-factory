# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hubot_factory/version"

Gem::Specification.new do |s|
  s.name        = "hubot_factory"
  s.version     = HubotFactory::VERSION
  s.authors     = ["Tom Bell"]
  s.email       = ["tomb@tombell.org.uk"]
  s.homepage    = ""
  s.summary     = %q{A Sinatra application for building a Hubot}
  s.description = %q{A Sinatra application for building a Hubot}

  s.rubyforge_project = "hubot_factory"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "mustache"
  s.add_runtime_dependency "sinatra"
  s.add_runtime_dependency "thin"
end
