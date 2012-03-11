Cassandra Integration
=====================

This gem should help you integrate data from models of different Rails apps using Apache Cassandra to replicate them.

##References

[Apache Cassandra](http://cassandra.apache.org/)
[Apache Cassandra - Wiki](http://wiki.apache.org/cassandra/FrontPage)
 

##Installation

Include the gem in your Gemfile:

    gem "cassandra_integration", :git => "git://github.com/dtmconsultoria/cassandra-integration.git"
    bundle install
  
    bundle exec rails generate cassandra_integration_config
    #The generate command will create cassandra_integration.yml file on your config directory
        

cassandra_integration.yml
        
    development:
        host: 192.168.0.1:9160
         keyspace: keyspace
         app_id: id_for_this_application
         other_apps_ids: id_for_other_app1,id_for_other_app2
         retries: 3
         timeout: 10
         connect_timeout: 20
    

##Quick Start

On Cassandra, you must create a ColumnFamily:

**Attention for the last 3 column names. They are the apps identifiers configured on your cassandra_integration.yml**

    create column family your_column_famly_name WITH comparator = UTF8Type
       AND key_validation_class = UTF8Type
       AND column_metadata = [
               {column_name: name, validation_class: UTF8Type, index_type: KEYS},
               {column_name: birth_date, validation_class: UTF8Type},
               {column_name: mother_name, validation_class: UTF8Type},

               {column_name: id_for_this_application, validation_class: UTF8Type, index_type: KEYS},
               {column_name: id_for_other_app1, validation_class: UTF8Type, index_type: KEYS}
               {column_name: id_for_other_app2, validation_class: UTF8Type, index_type: KEYS}];


You must create a migration for each model you want to sync:

    add_column :your_model_name, :cassandra_sync_identifier, :string

On each model:

    class User < ActiveRecord::Base
      extend CassandraIntegration::Base
    
      #Here goes the ColumnFamily name used to sync this model data 
      self.cassandra_column_family = 'people'
    
      def to_cassandra_sync_identifier
        #Here goes your unique identifier for all systems
        #That will be the Cassandra's key identifier
        "#{name.parameterize}##{mother.parameterize}##{birthdate}"
      end
    
      #Here goes the fields you want to sync
      #The hash key is the column name on Cassandra and
      #the hash value is the attribute name on your model
      self.cassandra_columns_values_hash = {
        :name        => 'name',
        :mother_name => 'mother',
        :birth_date  => 'birthdate'
      }
  
    end