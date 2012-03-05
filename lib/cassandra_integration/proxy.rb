require 'cassandra'
class CassandraIntegration::Proxy
  
  attr_reader :cassandra, :instance
  
  def initialize(instance)
    connect
    @instance = instance
  end
  
  def sync
    values = { 'name'        => @instance.name,
              'mother_name' => @instance.mother,
              'birth_date'  => @instance.birthdate.to_s,
              CassandraIntegration::Config.app_id => CassandraIntegration::Config.app_id  }
    
    @cassandra.insert(@instance.class.cassandra_column_family, @instance.cassandra_sync_identifier, values) unless record_exists?
  end
  
  def record_exists?
    !@cassandra.get(@instance.class.cassandra_column_family, @instance.cassandra_sync_identifier).blank?
  end
  
  def connect
    @cassandra = Cassandra.new(CassandraIntegration::Config.keyspace, CassandraIntegration::Config.host)
  end
  
end