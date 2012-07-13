require 'spec_helper'
require 'dummy_class'

describe CassandraIntegration::Base do

  let(:dummy) { DummyClass.new }

  it 'should let set and get cassandra_column_family' do
    DummyClass.cassandra_column_family = 'cassandra_column_family'
    DummyClass.cassandra_column_family.should eq('cassandra_column_family')
  end

  it 'should let set and get cassandra_columns_values_hash' do
    DummyClass.cassandra_columns_values_hash = 'cassandra_columns_values_hash'
    DummyClass.cassandra_columns_values_hash.should eq('cassandra_columns_values_hash')
  end

  it 'cassandra_columns_values_hash should be a Hash' do
    DummyClass.cassandra_columns_values_hash = {}
    DummyClass.cassandra_columns_values_hash.should be_an_instance_of Hash
  end

  it 'should call replicate callback method when create is called' do
    dummy.should_receive(:replicate)
    dummy.save
  end

  it 'should call set_cassandra_sync_identifier callback method when validation is called' do
    dummy.should_receive(:set_cassandra_sync_identifier)
    dummy.valid?
  end

  describe '#coming_from_cassandra?' do
    it 'should let set coming_from_cassandra' do
      dummy.coming_from_cassandra?.should be false
      dummy.coming_from_cassandra = true
      dummy.coming_from_cassandra?.should be true
    end
  end

  describe '#replicate' do

    it 'should do nothing if config is empty' do
      CassandraIntegration::Proxy.should_not_receive(:new)
      dummy.replicate
    end

    it 'should return true if config is empty' do
      CassandraIntegration::Proxy.should_not_receive(:new)
      dummy.replicate.should be true
    end

    describe 'with config loaded' do
      before { CassandraIntegration::Config.stub(:empty?).and_return(false) }

      it 'should create a Proxy passing extended class object as argument' do
        CassandraIntegration::Proxy.should_receive(:new).with(dummy).and_return(mock(:sync => true))
        dummy.replicate
      end

      it 'should call Proxy sync method' do
        proxy = mock(:proxy)
        proxy.should_receive(:sync)
        CassandraIntegration::Proxy.stub!(:new).and_return(proxy)
        dummy.replicate
      end

      it 'should call Proxy sync method if record is not coming from cassandra' do
        proxy = mock(:proxy)
        proxy.should_receive(:sync)
        CassandraIntegration::Proxy.stub!(:new).and_return(proxy)
        dummy.replicate
      end

    end

    it 'should not call Proxy sync method if record is coming from cassandra' do
      proxy = mock(:proxy)
      proxy.should_not_receive(:sync)
      CassandraIntegration::Proxy.stub!(:new).and_return(proxy)
      dummy.coming_from_cassandra = true
      dummy.replicate
    end

  end

  describe '#set_cassandra_sync_identifier' do

    it 'should do nothing if config is empty' do
      dummy.should_not_receive(:respond_to?).with(:cassandra_sync_identifier)
      dummy.should_not_receive(:to_cassandra_sync_identifier)
      dummy.set_cassandra_sync_identifier
    end

    it 'should return true if config is empty' do
      dummy.set_cassandra_sync_identifier.should be true
    end

    describe 'with config loaded' do
      before { CassandraIntegration::Config.stub(:empty?).and_return(false) }

      it "should raise exception if cassandra_sync_identifier attribute was not created on extended class" do
        expect { dummy.set_cassandra_sync_identifier }.to raise_error('Your model does not have cassandra_sync_identifier column.')
      end

      it "should verify if cassandra_sync_identifier was created on extended class" do
        class DummyClass
          attr_accessor :cassandra_sync_identifier
        end
        dummy.stub!(:to_cassandra_sync_identifier).and_return('to_cassandra_sync_identifier')
        dummy.set_cassandra_sync_identifier.should eq('to_cassandra_sync_identifier')
      end

    end

  end

  describe '#to_cassandra_sync_identifier' do

    it "should return default cassandra_sync_identifier" do
      CassandraIntegration::Config.stub!(:app_id).and_return('app_id')
      Float.stub!(:rand).and_return(1)

      dummy.to_cassandra_sync_identifier.should match(/#{Time.now.strftime('%Y%m%d%H%M%S')}#\d{,4}#APP_ID/)
    end

  end

end
