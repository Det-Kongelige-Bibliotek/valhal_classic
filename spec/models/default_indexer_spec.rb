require 'spec_helper'

describe DefaultIndexer do
  before(:each) do
    @index = DefaultIndexer.new
  end

  it 'should be able to add a field use a Hash' do
    @index.add_field("test", :string)
  end

  it "should be able to extract the solr field name" do
    @index.add_field("solr", :string)
    @index.solr.should == "solr_ssi"
  end
  context "with a Book" do
    before(:each) do
      @book = Book.new
    end

    it "should be able to generate a Hash with solr names and values from the class" do
      book = Book.new(title: "TestTitle")
      index = DefaultIndexer.new(book)
      index.add_field("title", :text)
      index.generate_solr_doc.should == { 'title_tsi' => "TestTitle"}
    end

    it "should return a empty hash when no fields have an value " do
      index = DefaultIndexer.new(@book)
      index.add_field("title", :text)
      index.generate_solr_doc.should == {}
    end


  end




end