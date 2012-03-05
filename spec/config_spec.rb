require 'tempfile'
require File.dirname(__FILE__) + '/spec_helper'

describe CassandraIntegration::Config do

  describe ".configure" do

    it "should parse yaml file" do
      m = mock(:yaml_file)
      File.stub!(:read).and_return(m)
      YAML.should_receive(:load).with(m)
      CassandraIntegration::Config.configure(mock)
    end

    it "should read the config file" do
      file = Tempfile.new('config')
      file.write("host: test.com\n")
      file.write("keyspace: keyspace\n")
      file.flush
      
      CassandraIntegration::Config.configure(file.path)
      CassandraIntegration::Config.host.should eq('test.com')
      CassandraIntegration::Config.keyspace.should eq('keyspace')
    end

  end

end