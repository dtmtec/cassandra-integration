class CassandraIntegrationConfigGenerator < Rails::Generators::Base
  
  source_root File.expand_path('../templates', __FILE__)
  
  desc "Generate CassandraIntegration config file"
  def create_cassandra_integration_config_file
   copy_file 'cassandra_integration.yml', 'config/cassandra_integration.yml' 
  end
  
end