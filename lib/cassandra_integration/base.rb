module CassandraIntegration::Base

  attr_accessor :cassandra_column_family, :cassandra_columns_values_hash

  def self.extended(base)
    base.after_save :replicate
    base.before_validation :set_cassandra_sync_identifier
    
    CassandraIntegration::Config.extended_models=base.name

    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def replicate
      CassandraIntegration::Proxy.new(self).sync
    end
    
    def set_cassandra_sync_identifier
      raise 'Your model does not have cassandra_sync_identifier column.' unless self.respond_to? :cassandra_sync_identifier
      self.cassandra_sync_identifier = to_cassandra_sync_identifier if self.cassandra_sync_identifier.blank?
    end
    
    def to_cassandra_sync_identifier
      raise 'Method to_cassandra_sync_identifier is not implemented!'
    end
  end
end