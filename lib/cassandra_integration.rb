require "cassandra_integration/version"
require "cassandra_integration/base"
require "cassandra_integration/proxy"
require "cassandra_integration/config"

module CassandraIntegration
end

if defined?(Rails)
  require 'cassandra_integration/railtie'
end