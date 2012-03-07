require File.dirname(__FILE__) + '/spec_helper'

describe CassandraIntegration::Proxy do

  it "should connect to Cassandra" do
    CassandraIntegration::Proxy.any_instance.should_receive(:connect)
    CassandraIntegration::Proxy.new(mock)
  end

  describe "#connect" do
    it "should set a Cassandra object connection" do
      CassandraIntegration::Proxy.new(mock).cassandra.should be_an_instance_of Cassandra 
    end

    it "should set instance variable" do
      m = mock
      CassandraIntegration::Proxy.new(m).instance.should be_an_instance_of m.class
    end
  end

  describe "#sync" do

    it "should sync user to Cassandra" do
      instance = extended_method_mock
      CassandraIntegration::Proxy.any_instance.stub(:connect)
      CassandraIntegration::Proxy.any_instance.stub(:record_exists?)
      proxy = CassandraIntegration::Proxy.new(instance)
      cassandra = mock(:cassandra)
      cassandra.should_receive(:insert).with('cassandra_column_family', 'cassandra_sync_identifier', hash_values_to_cassandra)
      proxy.instance_variable_set(:@cassandra, cassandra)
      proxy.sync
    end

  end

  describe "#record_exists?" do

    it "should verify if method exists" do
      CassandraIntegration::Proxy.any_instance.should_receive(:record_exists?)
      CassandraIntegration::Proxy.new(mock).record_exists?
    end

  end

  describe "#cassandra_coloumns_values_hash" do

    it "should return a hash containing cassandra columns and their values for instance object based on cassandra_coloumns_values_hash defined on extended model" do
      CassandraIntegration::Proxy.any_instance.stub(:connect)
      CassandraIntegration::Proxy.new(extended_method_mock).cassandra_columns_values_hash.should eq(hash_values_to_cassandra)
    end

  end

end

private
  def hash_values_to_cassandra
    { 'name' => 'name',
      'mother_name' => 'mother',
      'birth_date' => 'birthdate',
      'app_id' => 'app_id' }
  end

  def extended_method_mock
    mock(
      :class => mock(:cassandra_column_family => 'cassandra_column_family', :cassandra_columns_values_hash => hash_values_to_cassandra),
      :cassandra_sync_identifier => 'cassandra_sync_identifier',
      :name => 'name',
      :mother => 'mother',
      :birthdate => 'birthdate',
      :app_id => 'app_id'
    )
  end