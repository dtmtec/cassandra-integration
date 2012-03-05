class DummyClass
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  define_model_callbacks :save
  
  extend CassandraIntegration::Base

  def save
    run_callbacks :save do
      # Your save action methods here
    end
  end
  
end