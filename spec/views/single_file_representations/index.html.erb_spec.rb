require 'spec_helper'

describe "single_file_representations/index" do
  before(:each) do
    assign(:single_file_representations, [
      stub_model(SingleFileRepresentation),
      stub_model(SingleFileRepresentation)
    ])
  end

  it "renders a list of single_file_representations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
