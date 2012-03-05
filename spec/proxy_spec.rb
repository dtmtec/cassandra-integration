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
      instance = mock(
        :class => mock(:cassandra_column_family => 'cassandra_column_family'),
        :cassandra_sync_identifier => 'cassandra_sync_identifier',
        :name => 'name',
        :mother => 'mother',
        :birthdate => 'birthdate'
      )
      CassandraIntegration::Proxy.any_instance.stub(:connect)
      CassandraIntegration::Proxy.any_instance.stub(:record_exists?)
      proxy = CassandraIntegration::Proxy.new(instance)
      cassandra = mock('cassandra')
      cassandra.should_receive(:insert).with('cassandra_column_family', 'cassandra_sync_identifier', {
        'name' => 'name',
        'mother_name' => 'mother',
        'birth_date' => 'birthdate'
      })
      proxy.instance_variable_set(:@cassandra, cassandra)
      proxy.sync
    end

  end

  describe "#record_exists?" do

    it "should verify if method exists" do
      m = mock
      CassandraIntegration::Proxy.any_instance.should_receive(:record_exists?)
      CassandraIntegration::Proxy.new(m).record_exists?
    end

  end

end