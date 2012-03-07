Cassandra Integration
=====================

This gem should help you integrate data from models of different rails apps using Cassandra to replicate them. 

*Installation*

Include the gem in your Gemfile:

    gem "cassandra_integration", :git => "git://github.com/dtmconsultoria/cassandra-integration.git"
  
    bundle install
  
    bundle exec rails generate cassandra_integration_config

*Quick Start*

In your model:

    class User < ActiveRecord::Base
      extend CassandraIntegration::Base
    
      self.cassandra_column_family = 'people'
    
      def to_cassandra_sync_identifier
        "#{name.parameterize}##{mother.parameterize}##{birthdate}"
      end
    
      self.cassandra_columns_values_hash = {
        :name        => 'name',
        :mother_name => 'mother',
        :birth_date  => 'birthdate'
      }
  
    end

