# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "ordered_representations/show" do
  before(:each) do
    @ordered_representation = assign(:ordered_representation, stub_model(OrderedRepresentation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
