require 'spec_helper'


describe Solr::DefaultIndexer do

  context "with a Book" do
    it "should be able to generate a Hash with solr names and values from the class" do
      book = Book.new(title: "TestTitle")
      index = Solr::DefaultIndexer.new(book)
      index.generate_solr_doc.should == { 'search_result_title_tsi' => "TestTitle", "title_tsi"=>"TestTitle"}
    end

    it "should return a empty hash when no fields have an value " do
      book = Book.new
      index = Solr::DefaultIndexer.new(book)
      index.generate_solr_doc.should == {}
    end
  end

end