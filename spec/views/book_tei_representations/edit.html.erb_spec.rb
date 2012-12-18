require 'spec_helper'

describe "book_tei_representations/edit" do
  before(:each) do
    @book_tei_representation = assign(:book_tei_representation, stub_model(BookTeiRepresentation))
  end

  it "renders the edit book_tei_representation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => book_tei_representations_path(@book_tei_representation), :method => "post" do
    end
  end
end
