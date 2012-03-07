require 'cassandra'
class CassandraIntegration::Proxy
  
  attr_reader :cassandra, :instance
  
  def initialize(instance)
    connect
    @instance = instance
  end
  
  def sync
    @cassandra.insert(@instance.class.cassandra_column_family, @instance.cassandra_sync_identifier, cassandra_columns_values_hash) unless record_exists?
  end
  
  def record_exists?
    !@cassandra.get(@instance.class.cassandra_column_family, @instance.cassandra_sync_identifier).blank?
  end
  
  def cassandra_columns_values_hash
    data = Hash.new
    @instance.class.cassandra_columns_values_hash.each do |key, value|
      data[key.to_s] = @instance.send(value).to_s
    end
    return data
  end

  def connect
    @cassandra = Cassandra.new(CassandraIntegration::Config.keyspace, CassandraIntegration::Config.host)
  end
  
end