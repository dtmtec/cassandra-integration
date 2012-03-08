module Rails
  
  module Cassandraintegration
    if Rails.const_defined?(:Railtie)
      class Railtie < Rails::Railtie
        initializer "load CassandraIntegraion config file" do
          CassandraIntegration::Config.configure(Rails.root.join('config', 'cassandra_integration.yml'))
        end
      
        rake_tasks do
          load 'cassandra_integration/railties/cassandra_integration.rake'
        end
            
      end
    end
  end
  
end