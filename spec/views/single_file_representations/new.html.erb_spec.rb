require 'spec_helper'

describe "single_file_representations/new" do
  before(:each) do
    assign(:single_file_representation, stub_model(SingleFileRepresentation).as_new_record)
  end

  it "renders new single_file_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => single_file_representations_path, :method => "post" do
    end
  end
end
