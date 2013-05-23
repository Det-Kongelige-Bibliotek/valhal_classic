# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "works/new" do
  before(:each) do
    assign(:work, stub_model(Work).as_new_record)
  end

  it "renders new work form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => works_path, :method => "post" do
    end
  end
end
