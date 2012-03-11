require 'cassandra'
class CassandraIntegration::Proxy
  
  attr_reader :instance
  
  def initialize(instance)
    @instance = instance
  end
  
  def sync
    self.class.connect.insert(@instance.class.cassandra_column_family,
                      @instance.cassandra_sync_identifier,
                      cassandra_columns_values_hash.merge(CassandraIntegration::Proxy.set_apps_to_update)) unless record_exists?
  end

  def self.set_apps_to_update
    apps = CassandraIntegration::Config.other_apps_ids
    apps.split(',').reduce({}) { |data, app| data.tap { data[app] = app } }
  end
  
  def record_exists?
    !self.class.connect.get(@instance.class.cassandra_column_family, @instance.cassandra_sync_identifier).blank?
  end
  
  def cassandra_columns_values_hash
    values = @instance.class.cassandra_columns_values_hash
    values.reduce({}) { |data, (key, value)| data.tap { data[key.to_s] = @instance.send(value).to_s } }
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