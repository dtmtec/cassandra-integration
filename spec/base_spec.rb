require File.dirname(__FILE__) + '/spec_helper'
require 'dummy_class'

describe CassandraIntegration::Base do

  let(:dummy) {DummyClass.new}

  it 'should call my callback method when create is called' do
    dummy.should_receive(:replicate)
    dummy.save
  end

  it 'should call my callback method when validation is called' do
    dummy.should_receive(:set_cassandra_sync_identifier)
    dummy.valid?
  end

  it 'should permit alter cassandra column family name' do
    DummyClass.cassandra_column_family = 'cassandra_column_family'
    DummyClass.cassandra_column_family.should eq('cassandra_column_family')
  end

  describe '#replicate' do

    it 'should create a Proxy passing self as argument' do
      CassandraIntegration::Proxy.should_receive(:new).with(dummy).and_return(mock(:sync => true))
      dummy.replicate
    end

    it 'should call Proxy sync method' do
      proxy = mock(:proxy)
      proxy.should_receive(:sync)
      CassandraIntegration::Proxy.stub!(:new).and_return(proxy)
      dummy.replicate
    end

  end

  describe '#to_cassandra_sync_identifier' do

    it "should raise 'not implemented'" do
      expect {dummy.to_cassandra_sync_identifier}.to raise_error('Method to_cassandra_sync_identifier is not implemented!')
    end

  end

  describe '#set_cassandra_sync_identifier' do

    it "should raise exception if cassandra_sync_identifier was not created" do
      expect {dummy.set_cassandra_sync_identifier}.to raise_error('Your model does not have cassandra_sync_identifier column.')
    end

    it "should verify if cassandra_sync_identifier was created" do
      class DummyClass
        attr_accessor :cassandra_sync_identifier
      end
      dummy.stub!(:to_cassandra_sync_identifier).and_return('to_cassandra_sync_identifier')
      dummy.set_cassandra_sync_identifier.should eq('to_cassandra_sync_identifier')
    end

  end

end