# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cassandra_integration/version"

Gem::Specification.new do |s|
  s.name        = "cassandra_integration"
  s.version     = CassandraIntegration::VERSION
  s.authors     = ["Marcelo Murad"]
  s.email       = ["marcelo.murad@dtmconsultoria.com"]
  s.homepage    = "http://dtmconsultoria.com"
  s.summary     = %q{Permits integrate models from diferent apps using Cassandra for sync}
  s.description = %q{Permits integrate models from diferent apps using Cassandra for sync}

  s.rubyforge_project = "cassandra_integration"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "activemodel"
  s.add_runtime_dependency "cassandra", ">= 0.12.1"
  s.add_runtime_dependency "thrift_client", "~> 0.7.0"
end
