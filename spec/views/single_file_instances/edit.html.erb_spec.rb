# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "single_file_instances/edit" do
  before(:each) do
    @single_file_instance = SingleFileInstance.create!
    # @single_file_instance = assign(:single_file_instance, stub_model(SingleFileInstance))
  end

  it "renders the edit single_file_instance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => single_file_instances_path(@single_file_instance), :method => "post" do
    end
  end
end
