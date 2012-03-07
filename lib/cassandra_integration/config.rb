require 'yaml'
class CassandraIntegration::Config

  def self.configure(yaml)
    @@config = YAML::load(File.read(yaml))
  end
  
  def self.host
    @@config[RAILS_ENV]['host']
  end
  
  def self.keyspace
    @@config[RAILS_ENV]['keyspace']
  end

  def self.app_id
    @@config[RAILS_ENV]['app_id']
  end

end