require 'yaml'
class CassandraIntegration::Config

  def self.configure(yaml)
    @@config = YAML::load(File.read(yaml))
  end
  
  def self.host
    @@config['host']
  end
  
  def self.keyspace
    @@config['keyspace']
  end
end