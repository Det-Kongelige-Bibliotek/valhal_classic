require 'spec_helper'

describe "person_tei_representations/index" do
  before(:each) do
    assign(:person_tei_representations, [
      stub_model(PersonTeiRepresentation),
      stub_model(PersonTeiRepresentation)
    ])
  end

  it "renders a list of person_tei_representations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
