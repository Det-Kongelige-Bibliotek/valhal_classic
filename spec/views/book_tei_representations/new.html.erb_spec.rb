require 'spec_helper'

describe "book_tei_representations/new" do
  before(:each) do
    assign(:book_tei_representation, stub_model(BookTeiRepresentation).as_new_record)
  end

  it "renders new book_tei_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => book_tei_representations_path, :method => "post" do
    end
  end
end
