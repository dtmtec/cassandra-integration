namespace :cassandra_integration do
  desc 'Update cassandra second indexex'
  task :update_second_indexes => :environment do
    Dir.glob(Rails.root.join('app/models/**/*.rb')).each { |path| require path }
    #CassandraIntegration::Proxy.connect
    proxy = CassandraIntegration::Proxy
    CassandraIntegration::Config.extended_models_cfs.uniq.compact.each do |cf|
      proxy.set_apps_to_update.each do |key,_|
        puts "Creating second index for CF #{cf} key #{key}."
        proxy.cassandra.create_index(CassandraIntegration::Config.keyspace, cf, key, 'UTF8Type')
      end
    end
    puts 'Indexes created!'
  end
end