# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "ordered_instances/edit" do
  before(:each) do
    # @ordered_instance = assign(:ordered_instance, stub_model(OrderedInstance))
    @ordered_instance = OrderedInstance.create!
  end

  it "renders the edit ordered_instance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ordered_instance_path(@ordered_instance), :method => "post" do
    end
  end
end
