# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PersonTeiRepresentationsController do
  #Login a test user with admin rights
  before(:each) do
    login_admin
  end

  describe "#index" do
    before do
      @person_tei_representation = PersonTeiRepresentation.create
    end

    it "should have the newly created person_tei_representation in the index, and it should be of the type PersonTeiRepresentation" do
      get :index
      assigns[:person_tei_representations].should include @person_tei_representation
      assigns[:person_tei_representations].each { |ptr| ptr.should be_kind_of PersonTeiRepresentation }
      response.should be_successful
    end
  end

  describe "#new" do
    before do
      PersonTeiRepresentation.all.each { |ptr| ptr.delete }
    end

    it "should create a new instance of type PersonTeiRepresentation" do
      get :new
      assigns[:person_tei_representation].should be_kind_of PersonTeiRepresentation
      response.should be_successful
    end

    it "should allow uploading a TEI file" do
      file = fixture_file_upload('/aarrebo_tei_p5_sample.xml', 'text/xml')
      content = File.open("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml", 'r:utf-8').read
      stub_temp = double("Tempfile")
      stub_temp.stub(:read).and_return(content)
      file.stub(:tempfile).and_return(stub_temp)
      post :create, :file_data => file
      response.should redirect_to person_tei_representations_path
      PersonTeiRepresentation.count.should == 1
      string_from_fedora = PersonTeiRepresentation.all.first.teiFile.content

      string_from_fedora.should be_equivalent_to content
    end
  end

  describe "#create" do
    before do
      PersonTeiRepresentation.find_each { |b| b.delete }
      PersonTeiRepresentation.count.should == 0
    end

    it "Should create a person_tei_representation" do
      post :create, :person_tei_representation => {:forename => "Dude", :surname => "Miller"}
      PersonTeiRepresentation.count.should == 1
      response.should redirect_to person_tei_representations_path
      flash[:notice].should_not be_nil
    end
  end

  describe "#edit" do
    before do
      @person_tei_representation = PersonTeiRepresentation.create
    end

    it "should be able to edit the requested person_tei_representation" do
      get :edit, :id => @person_tei_representation.pid
      assigns[:person_tei_representation].should == @person_tei_representation
      response.should be_successful
    end
  end

  describe "#update" do
    before do
      @person_tei_representation = PersonTeiRepresentation.create
    end

    it "should update the person_tei_representation" do
      put :update, :id => @person_tei_representation.pid, :person_tei_representation => {:forename => "Alex"}
      flash[:notice].should_not be_nil
      response.should redirect_to person_tei_representations_path
      @person_tei_representation = PersonTeiRepresentation.find(@person_tei_representation.pid)
      @person_tei_representation.forename.should == "Alex"
    end
  end

  describe "#show" do
    before do
      @person_tei_representation = PersonTeiRepresentation.create(forename: "Alex", surname: "Boesen")
    end

    it "should show the new created person_tei_representation" do
      get :show, :id => @person_tei_representation.pid
      assigns[:person_tei_representation].should == @person_tei_representation
      response.should be_successful
    end
  end

  describe "#destroy" do

  end
end
