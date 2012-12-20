require 'spec_helper'

describe "book_tei_representations/index" do
  before(:each) do
    book_tei_rep1 = BookTeiRepresentation.new
    book_tei_rep1.files << create_basic_file(book_tei_rep1)
    book_tei_rep1.save
    book_tei_rep2 = BookTeiRepresentation.new
    book_tei_rep2.files << create_basic_file(book_tei_rep2)
    book_tei_rep2.save

    assign(:book_tei_representations, [
        book_tei_rep1,
        book_tei_rep2
    ])
  end

  it "renders a list of book_tei_representations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
