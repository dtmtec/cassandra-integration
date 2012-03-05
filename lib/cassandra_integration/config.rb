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

  def self.app_id
    @@config['app_id']
  end

end