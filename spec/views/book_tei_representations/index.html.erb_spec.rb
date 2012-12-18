require 'spec_helper'

describe "book_tei_representations/index" do
  before(:each) do
    assign(:book_tei_representations, [
      stub_model(BookTeiRepresentation),
      stub_model(BookTeiRepresentation)
    ])
  end

  it "renders a list of book_tei_representations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
