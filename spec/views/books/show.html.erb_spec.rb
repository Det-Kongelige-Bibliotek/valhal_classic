# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "books/show" do
  describe 'default' do
    before(:each) do
      @book = assign(:book, stub_model(Book))
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
  end
end
