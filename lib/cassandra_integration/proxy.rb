require 'cassandra'
class CassandraIntegration::Proxy
  
  attr_reader :instance
  
  def initialize(instance)
    @instance = instance
  end
  
  def sync
    self.class.connect.insert(@instance.class.cassandra_column_family,
                      @instance.cassandra_sync_identifier,
                      cassandra_columns_values_hash.merge(CassandraIntegration::Proxy.set_apps_to_update))
  end

  def self.set_apps_to_update
    data = Hash.new
    CassandraIntegration::Config.other_apps_ids.split(',').each do |app|
      data[app.to_s] = app.to_s
    end
    data
  end
  
  def record_exists?
    !self.class.connect.get(@instance.class.cassandra_column_family, @instance.cassandra_sync_identifier).blank?
  end
  
  def cassandra_columns_values_hash
    data = Hash.new
    @instance.class.cassandra_columns_values_hash.each do |key, value|
      data[key.to_s] = @instance.send(value).to_s
    end
    return data
  end

  def self.connect
    @@cassandra ||= Cassandra.new(CassandraIntegration::Config.keyspace,
                                  CassandraIntegration::Config.host,
                                  :retires => CassandraIntegration::Config.retries,
                                  :timeout => CassandraIntegration::Config.timeout,
                                  :connect_timeout => CassandraIntegration::Config.connect_timeout)
  end
  
  def self.cassandra
    self.connect
  end
end