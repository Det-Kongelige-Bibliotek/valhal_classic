require 'spec_helper'

describe "person_tei_representations/edit" do
  before(:each) do
    @person_tei_representation = assign(:person_tei_representation, stub_model(PersonTeiRepresentation))
  end

  it "renders the edit person_tei_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => person_tei_representations_path(@person_tei_representation), :method => "post" do
    end
  end
end
