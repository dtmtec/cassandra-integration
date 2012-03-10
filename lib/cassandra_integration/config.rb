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

    def retries
      @@config[RAILS_ENV]['retries'] || 3
    end

    def timeout
      @@config[RAILS_ENV]['timeout'] || 10
    end

    def connect_timeout
      @@config[RAILS_ENV]['connect_timeout'] || 10
    end

    def extended_models
      @@extended_models
    end

    def extended_models=(value)
      @@extended_models << value
    end

  end

end