# encoding: utf-8
namespace :cassandra_integration do
  # desc 'Update cassandra second index'
  # task :update_second_indexes => :environment do
  #   Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |path| require path }
  #   
  #   proxy = CassandraIntegration::Proxy
  #   
  #   CassandraIntegration::Config.extended_models.uniq.compact.each do |model|
  #     cf = eval(model).cassandra_column_family
  #     proxy.set_apps_to_update.each do |key,_|
  #       proxy.cassandra.insert(cf, 'temp_index_to_rake_task', {key => key})
  #       sleep(3)
  #       puts "Creating second index for CF #{cf} key #{key}."
  #       proxy.cassandra.create_index(CassandraIntegration::Config.keyspace, cf, key, 'UTF8Type')
  #     end
  #     key = CassandraIntegration::Config.app_id
  #     proxy.cassandra.insert(cf, 'temp_index_to_rake_task', {key => key})
  #     sleep(3)
  #     puts "Creating second index for CF #{cf} key #{key}."
  #     proxy.cassandra.create_index(CassandraIntegration::Config.keyspace, cf, key, 'UTF8Type')
  #   
  #   end
  #   puts 'Indexes created!'
  # end
  
  desc 'Update models with cassandra data'
  task :update_models_with_cassandra => :environment do
    Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |path| require path }
    
    CassandraIntegration::Config.extended_models.uniq.compact.each do |model_name|
      model = eval(model_name)
      cf = model.cassandra_column_family
      app_id = CassandraIntegration::Config.app_id
      
      proxy = CassandraIntegration::Proxy
      search = [{ :column_name => app_id, :value => app_id, :comparison => '==' }]
      records_to_update = proxy.cassandra.get_indexed_slices(cf, search)
      puts "Records to update:  #{records_to_update.length}"
      records_to_update.each do |key,_|

        puts '=================================='
        puts "cassandra_sync_identifier: #{key}"

        if model.find_by_cassandra_sync_identifier(key).blank?
          cassandra_record = proxy.cassandra.get(cf, key)
          obj = model.new

          model.cassandra_columns_values_hash.each do |cassandra_col, model_col|
            obj[model_col] = cassandra_record[cassandra_col.to_s]
          end
          obj[:cassandra_sync_identifier] = key
          obj.coming_from_cassandra = true

          if obj.save!
            puts 'Registro criado com sucesso!'
            proxy.cassandra.remove(cf, key, app_id)
            puts "Removing #{app_id} from #{key} to CF #{cf}."
          end

        else

          puts "Chave: já existe no bd."
          proxy.cassandra.remove(cf, key, app_id)
          puts "Removing #{app_id} from #{key} to CF #{cf}."

        end

      end

    end

  end

end