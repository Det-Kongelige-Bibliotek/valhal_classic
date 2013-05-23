# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "single_file_representations/show" do
  before(:each) do
    @single_file_representation = assign(:single_file_representation, stub_model(SingleFileRepresentation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
