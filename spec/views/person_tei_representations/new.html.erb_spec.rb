require 'spec_helper'

describe "person_tei_representations/new" do
  before(:each) do
    assign(:person_tei_representation, stub_model(PersonTeiRepresentation).as_new_record)
  end

  it "renders new person_tei_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => person_tei_representations_path, :method => "post" do
    end
  end
end
