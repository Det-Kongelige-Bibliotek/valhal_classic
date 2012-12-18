require 'spec_helper'

describe "book_tei_representations/show" do
  before(:each) do
    @book_tei_representation = assign(:book_tei_representation, stub_model(BookTeiRepresentation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
