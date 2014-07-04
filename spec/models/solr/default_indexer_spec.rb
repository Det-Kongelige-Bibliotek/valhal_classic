require 'spec_helper'


describe Solr::DefaultIndexer do

  context "with a Work" do
    it "should be able to generate a Hash with solr names and values from the class" do
      work = Work.new(title: "TestTitle")
      index = Solr::DefaultIndexer.new(work)
      index.generate_solr_doc.should == { 'search_result_title_tsi' => "TestTitle", "title_tsi"=>"TestTitle"}
    end

    it "should return a empty hash when no fields have an value " do
      work = Work.new
      index = Solr::DefaultIndexer.new(work)
      index.generate_solr_doc.should == {}
    end
  end

end