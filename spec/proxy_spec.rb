require File.dirname(__FILE__) + '/spec_helper'

describe CassandraIntegration::Proxy do

  describe ".connect" do
    it "should set a Cassandra object connection" do
      CassandraIntegration::Proxy.connect.should be_an_instance_of Cassandra
    end

    it "should set instance variable" do
      m = mock
      CassandraIntegration::Proxy.new(m).instance.should be_an_instance_of m.class
    end
  end

  describe ".cassandra" do
    it "should return a Cassandra object connection" do
      CassandraIntegration::Proxy.cassandra.should be_an_instance_of Cassandra
    end
  end

  describe "#sync" do

    it "should sync user to Cassandra" do
      cassandra = mock(:cassandra)
      CassandraIntegration::Proxy.stub(:connect => cassandra)
      CassandraIntegration::Proxy.any_instance.stub(:record_exists? => false)
      CassandraIntegration::Proxy.stub(:set_apps_to_update => {})
      cassandra.should_receive(:insert).with('cassandra_column_family', 'cassandra_sync_identifier', hash_values_to_cassandra)
      CassandraIntegration::Proxy.new(extended_method_mock).sync
    end

  end

  describe ".set_apps_to_update" do

    it "should return a Hash of apps that need to be updated" do
      CassandraIntegration::Config.stub(:other_apps_ids=>'app1,app2')
      CassandraIntegration::Proxy.stub(:connect)
      CassandraIntegration::Proxy.set_apps_to_update.should eq({'app1'=>'app1', 'app2'=>'app2'})
    end

  end

  describe "#record_exists?" do

    it "should verify if method exists" do
      CassandraIntegration::Proxy.any_instance.should_receive(:record_exists?)
      CassandraIntegration::Proxy.new(mock).record_exists?
    end

    it "Cassandra get should return true" do
      CassandraIntegration::Proxy.stub(:connect => stub(:get => true))
      CassandraIntegration::Proxy.connect.should_receive(:get).and_return(true)

      p = CassandraIntegration::Proxy.new(extended_method_mock)
      p.record_exists?.should be true
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