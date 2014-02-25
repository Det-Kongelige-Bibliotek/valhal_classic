# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "books/index" do
  before(:each) do
    assign(:books, [
      stub_model(Book),
      stub_model(Book)
    ])
  end

end
