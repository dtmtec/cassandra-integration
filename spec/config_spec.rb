require 'tempfile'
require File.dirname(__FILE__) + '/spec_helper'

describe CassandraIntegration::Config do

  it "should let set any models to extended_models" do
    CassandraIntegration::Config.extended_models = 'person'
    CassandraIntegration::Config.extended_models = 'person2'
    CassandraIntegration::Config.extended_models.should include('person2','person')
  end

  describe ".configure" do

    it "should parse yaml file" do
      m = mock(:yaml_file)
      File.stub!(:read).and_return(m)
      YAML.should_receive(:load).with(m)
      CassandraIntegration::Config.configure(mock)
    end

    it "should read the development config file" do
      RAILS_ENV='development'
      file = Tempfile.new('config')
      file.write("development:\n")
      file.write("    host: test.com\n")
      file.write("    keyspace: keyspace\n")
      file.write("    app_id: app_id\n")
      file.write("    other_apps_ids: app2_id,app3_id\n")
      file.write("    retries: 3\n")
      file.write("    timeout: 10\n")
      file.write("    connect_timeout: 20\n")
      file.write("\n")
      file.write("production:\n")
      file.write("    host: test.com\n")
      file.write("    keyspace: keyspace\n")
      file.write("    app_id: app_id\n")
      file.write("    other_apps_ids: app2_id,app3_id\n")
      file.write("    retries: 3\n")
      file.write("    timeout: 10\n")
      file.write("    connect_timeout: 20\n")
      file.flush
      
      CassandraIntegration::Config.configure(file.path)
      CassandraIntegration::Config.host.should eq('test.com')
      CassandraIntegration::Config.keyspace.should eq('keyspace')
      CassandraIntegration::Config.app_id.should eq('app_id')
      CassandraIntegration::Config.other_apps_ids.should eq('app2_id,app3_id')
      CassandraIntegration::Config.retries.should eq(3)
      CassandraIntegration::Config.timeout.should eq(10)
      CassandraIntegration::Config.connect_timeout.should eq(20)
    end

  end

end