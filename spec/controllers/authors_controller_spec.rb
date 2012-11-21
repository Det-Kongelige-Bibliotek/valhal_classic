# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AuthorsController do
  describe "#new" do
    it "should be successful" do
      get :new
      assigns[:author].should  should be_kind_of Author
      response.should be_successful
    end
  end


  describe "#review" do
    it ""   do
      pending "There is review"
      put :review, :author=>{:surname => @author.surname}
      response.should redirect_to  author_view_path
    end
  end


  describe "#create" do
    before do
      Author.find_each {|b| b.delete}
      Author.count.should == 0;
    end

    it "Should have Surname"  do
      post :create, :author => {:surname => "Miller"}
      #assigns[:author].errors[:new].should ==  ['Please write a surname]
      Author.count.should == 1
    end
  end
end
