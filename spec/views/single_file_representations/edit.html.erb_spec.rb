require 'spec_helper'

describe "single_file_representations/edit" do
  before(:each) do
    @single_file_representation = assign(:single_file_representation, stub_model(SingleFileRepresentation))
  end

  it "renders the edit single_file_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => single_file_representations_path(@single_file_representation), :method => "post" do
    end
  end
end
