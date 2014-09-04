require 'spec_helper'

# Note that most test functionality has been moved
# into parse_letters below - this is because the perform method
# takes a docxml file which we don't know how to split up.
# Instead we take a smaller tei file and test the parsing methods
# using that. For this reason, the perform test is set to pending.

describe 'perform' do

  before {
    pending 'These tests are extremely long and should only be run when developing the LetterVolumeSplitter'
  }

  before :all do
    # create a sample work with a ordered instance
    # containing a basic file
    @work = Work.new
    o = OrderedInstance.new
    bf = BasicFile.new
    @xml_path = Rails.root.join('spec', 'fixtures', 'brev', 'small-tei.xml')
    bf.add_file(File.new(@xml_path), true)
    o.files << bf
    @work.add_instance(o)

    LetterVolumeSplitter.perform(@work.pid, bf.pid)

  end

  after :all do
    delete_all_objects
  end

  it 'should throw an error if called with an invalid work pid' do
    expect { LetterVolumeSplitter.perform('reallynotapid', '')}.to raise_error
  end

end
describe 'parse letters' do

  before :all do
    doc = Nokogiri::XML(File.open(Rails.root.join('spec', 'fixtures', 'brev', 'small-tei.xml')))
    @work = Work.create(title: 'The collected letters of Julius Lange', workType: 'Book')
    LetterVolumeSplitter.parse_letters(doc, @work)
    @letters = Work.find(search_result_work_type_ssi: 'Letter')
    @letter = Work.find(teiRef_si: 'divid136080').first
  end

  after :all do
    delete_all_objects
  end

  it 'should create a letter work for each div within the tei file' do
    @letters.size.should eql 2
    l = @letters[1]
    l.reload
    l.workType.should eql 'Letter'
    l.is_part_of.should == @work
    prev = l.previous_work
    prev.next_work.should == l
  end

  it 'should create an authority metadata unit for the author' do
    @letters[1].hasAuthor.should_not be_empty
    @letters[1].hasAuthor.first.should be_an AuthorityMetadataUnit
    @letters[1].hasAuthor.first.type.should eql 'agent/person'
  end

  it 'should create an authority metadata unit for the recipient' do
    @letter.should_not be_nil
    @letter.hasAddressee.first.should be_an AuthorityMetadataUnit
    @letter.hasAddressee.first.value.should eql 'CHR. RICHARD'
  end

  it 'should create an authority metadata unit for the sender address' do
    origin = @letter.hasOrigin.first
    origin.should be_an AuthorityMetadataUnit
    origin.type.should eql 'place'
    origin.value.should eql 'København'
  end

  it 'should create a basic file for the relevant tei div' do
    @letter.single_file_instances.length.should eql 1
  end
end

describe 'parse_metadata' do
  it 'should return a hash containing the correct values for a given div' do
    xml_path = Rails.root.join('spec', 'fixtures', 'brev', 'sort-of-tei.xml')
    xml = Nokogiri::XML(File.new(xml_path))
    div = xml.css('text body div').first
    data = LetterVolumeSplitter.parse_data(div)
    data.should be_a Hash
    data[:id].should eql 'divid136080'
    data[:num].should eql '1'
    data[:date].should eql '1. stpt. 1864'
    data[:body].should include 'Kære Richardt!'
    data[:sender_name].should eql 'Julius Lange.'
    data[:recipient_name].should eql 'CHR. RICHARD'
    data[:sender_address].should eql 'København'
    data[:note].should eql({displayLabel: 'noteFromText', value: 'TIL SAMME' })
    data[:needs_attention].should be_true
  end
end