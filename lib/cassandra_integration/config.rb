require 'yaml'
class CassandraIntegration::Config
  
  @@extended_models = []
  
  class << self

    def configure(yaml)
      @@config = YAML::load(File.read(yaml))
    end

    def host
      @@config[RAILS_ENV]['host']
    end

    def keyspace
      @@config[RAILS_ENV]['keyspace']
    end

    def app_id
      @@config[RAILS_ENV]['app_id']
    end

    def other_apps_ids
      @@config[RAILS_ENV]['other_apps_ids']
    end

    def extended_models
      @@extended_models
    end

    def extended_models=(value)
      @@extended_models << value
    end

  end

end