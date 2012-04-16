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

    attr_accessor :coming_from_cassandra

    def coming_from_cassandra?
      !self.coming_from_cassandra.blank?
    end

    def replicate
      CassandraIntegration::Proxy.new(self).sync unless self.coming_from_cassandra?
    end

    def set_cassandra_sync_identifier
      raise 'Your model does not have cassandra_sync_identifier column.' unless self.respond_to? :cassandra_sync_identifier
      self.cassandra_sync_identifier = to_cassandra_sync_identifier if self.cassandra_sync_identifier.blank?
    end

    def to_cassandra_sync_identifier
      "#{Time.now.strftime('%Y%m%d%H%M%S')}##{rand(1000)}##{CassandraIntegration::Config.app_id}".upcase
    end

  end

end