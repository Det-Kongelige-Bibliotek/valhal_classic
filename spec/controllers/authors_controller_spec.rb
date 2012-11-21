# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AuthorsController do
  describe "#index" do
    before do
      @author = Author.create
    end
    it "should be successful" do
      get :index
      assigns[:authors].should include @author
      assigns[:authors].each { |a| a.should be_kind_of Author }
      response.should be_successful
    end
  end

  describe "#new" do
    it "should be successful" do
      get :new
      assigns[:author].should be_kind_of Author
      response.should be_successful
    end
  end

  describe "#create" do
    before do
      Author.find_each { |b| b.delete }
      Author.count.should == 0
    end

    it "Should create a author" do
      post :create, :author => {:forename => "Dude", :surname => "Miller"}
      Author.count.should == 1
      response.should redirect_to authors_path
    end
  end

  describe "#edit" do
    before do
      @author = Author.create
    end
    it "should be successful" do
      get :edit, :id => @author.pid
      assigns[:author].should == @author
      response.should be_successful
    end
  end

  describe "#update" do
    before do
      @author = Author.create
    end

    it "should be successful" do
      put :update, :id => @author.pid, :author => {:forename => "Alex"}
      flash[:notice].should == "Forfatter er blevet ændret"
      response.should redirect_to authors_path
      @author = Author.find(@author.pid)
      @author.forename.should == "Alex"

    end

  end
end
