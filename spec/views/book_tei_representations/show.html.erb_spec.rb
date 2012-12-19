require 'spec_helper'

describe "book_tei_representations/show" do
  before(:each) do
    book_tei_rep = BookTeiRepresentation.new
    uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
    file = BasicFile.new
    file.add_file(uploaded_file)
    file.save
    book_tei_rep.file = file
    book_tei_rep.save
    @book_tei_representation = assign(:book_tei_representation, book_tei_rep)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
