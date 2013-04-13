require 'spec_helper'

describe Solr::SolrField do

  describe "::Create" do
    it 'should be able to take a name and return a SolrField with a name and solr_name with default values' do
      solr_field = Solr::SolrField.create("name")
      solr_field.solr_name.should == "name_tsi"
    end

    it "should be able to specify options on how the field are indexed" do
      solr_field = Solr::SolrField.create("name", index_as: [:string, :stored, :indexed])
      solr_field.solr_name.should == "name_ssi"
    end

    it 'should set the name as the method_name if nothing else is specifed' do
      solr_field = Solr::SolrField.create("name")
      solr_field.method_name.should == :name
    end

    it "should be able to pass in a method symbol as a option to set method name" do
      solr_field = Solr::SolrField.create("name", method: :first_name, index_as: [:string, :stored])
      solr_field.solr_name.should == "name_ss"
      solr_field.method_name.should == :first_name
    end

    it "should be able to pass in a block to be used when dealing with the values returned from methods" do
      solr_field = Solr::SolrField.create("name") { |value| value * 3 }
      solr_field.value_handler.call(3).should == 9
    end

    it "should set method_handler to nil when a block it not given" do
      solr_field = Solr::SolrField.create("name")
      solr_field.value_handler.should be_nil
    end

    it "should be possible to set all options and a block" do
      solr_field = Solr::SolrField.create("name", index_as: [:text, :stored, :multivalued], method: :first_name) { |value| value * 3}
      solr_field.solr_name.should == "name_tsm"
      solr_field.method_name.should == :first_name
      solr_field.value_handler.call(3).should == 9
    end

  end
end