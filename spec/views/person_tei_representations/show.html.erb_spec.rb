require 'spec_helper'

describe "person_tei_representations/show" do
  before(:each) do
    @person_tei_representation = assign(:person_tei_representation, stub_model(PersonTeiRepresentation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
