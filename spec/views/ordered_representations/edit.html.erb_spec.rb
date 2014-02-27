# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "ordered_representations/edit" do
  before(:each) do
    # @ordered_representation = assign(:ordered_representation, stub_model(OrderedRepresentation))
    @ordered_representation = OrderedRepresentation.create!
  end

  it "renders the edit ordered_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => ordered_representations_path(@ordered_representation), :method => "post" do
    end
  end
end
