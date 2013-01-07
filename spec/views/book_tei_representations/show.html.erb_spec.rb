# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "book_tei_representations/show" do
  before(:each) do
    book_tei_rep = BookTeiRepresentation.new
    book_tei_rep.files << create_basic_file(book_tei_rep)
    book_tei_rep.save
    @book_tei_representation = assign(:book_tei_representation, book_tei_rep)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
