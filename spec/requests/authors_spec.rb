# encoding: utf-8
require 'spec_helper'

describe "Authors" do
  it "should create a author" do
    pending

    visit new_author_path

    fill_in "Name", :with => "H.C Andersen"
    fill_in "Birth_death", :with => "1815 - 1875"
    fill_in "Quote", :with => "Alt på sin rette Plads!"
  end
end
