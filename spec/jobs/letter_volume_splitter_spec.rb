require 'spec_helper'

describe 'perform' do

  it 'should throw an error if called with an invalid work pid' do
    expect { LetterVolumeSplitter.perform('reallynotapid', '')}.to raise_error
  end

end
describe 'parse letters' do

  before :all do
    doc = Nokogiri::XML(File.open(Rails.root.join('spec', 'fixtures', 'brev', '001152195_000_tei.xml')))
    @work = Work.create(title: 'Breve fra Johannes Jørgensen til Vicko Stuckenberg', workType: 'Book')
    pics = OrderedInstance.new(contentType: 'jpg')
    path = Pathname.new(Rails.root).join('spec', 'fixtures', 'brev', '000773452_X01', '000773452_X01_0015.jpg')
    bf = basic_file_object(path)
    pics.files << bf
    @work.add_instance(pics)
    LetterVolumeSplitter.parse_letters(doc, @work)
    @letters = Work.find(search_result_work_type_ssi: 'Letter')
    @letter = Work.find(teiRef_si: 'divid182306').first
  end

  after :all do
    delete_all_objects
  end

  it 'should create a letter work for each div within the tei file' do
    @letters.size.should eql 2
    l = @letters[1]
    l.reload
    l.workType.should eql 'Letter'
    expect(l.is_part_of).to be_a Work
    prev = l.previous_work
    prev.next_work.should == l
  end

  it 'should create a Person object for the author' do
    @letters[1].hasAuthor.should_not be_empty
    @letters[1].hasAuthor.first.should be_a Person
    @letters[1].hasAuthor.first.type.should eql 'agent/person'
  end

  it 'should create a Person object for the recipient' do
    @letter.should_not be_nil
    @letter.hasAddressee.first.should be_a Person
    @letter.hasAddressee.first.lastName.should eql 'Stuckenberg'
  end

  it 'should create a Place object for the sender address' do
    origin = @letter.hasOrigin.first
    origin.should be_a Place
    origin.type.should eql 'place'
    origin.value.should eql 'København'
  end

  it 'should create a basic file for the relevant tei div' do
    @letter.single_file_instances.length.should eql 1
  end

  it 'should create a jpg ordered instance' do
    expect(@letter.ordered_instance_types[:jpgs]).to_not be_nil
  end
end

describe 'parse_metadata' do
  before :all do
    xml_path = Rails.root.join('spec', 'fixtures', 'brev', '001152195_000_tei.xml')
    @xml = Nokogiri::XML(File.new(xml_path))
  end

  it 'should return a hash containing the correct values for a given div' do
    div = @xml.css('text body div')[1]
    @data = LetterVolumeSplitter.parse_data(div, '')
    @data.should be_a Hash
    @data[:id].should eql 'divid182659'
    @data[:num].should eql '2'
    @data[:date].should eql 'd. 5. Maj 1887.'
    @data[:body].should include 'Paa Gaden — bag en Rude'
    @data[:sender_name].should eql 'J. J.'
    @data[:recipient_name].should eql 'VIGGO STUCKENBERG'
  end

  it 'should contain data for start page and end page when there is no end page' do
    div = @xml.css('text body div').first
    data = LetterVolumeSplitter.parse_data(div, '13')
    expect(data[:start_page]).to eql '15'
    expect(data[:end_page]).to eql '15'
  end

  it 'should contain data for start page and end page when there is an end page' do
    div = @xml.css('text body div')[1]
    data = LetterVolumeSplitter.parse_data(div, '13')
    expect(data[:end_page]).to eql '16'
  end

end

describe 'create_filename' do
  it 'should create a filename based on a prefix and a number' do
    fn = LetterVolumeSplitter.create_filename('001152195_000', '4')
    expect(fn).to eql '001152195_000_0004.jpg'
  end
end

describe 'create_jpg_oi' do
  before :all do
    @work = Work.create
    @data = {start_page: '1', end_page: '2'}
    @prefix = '000773452_X01'
    path = Pathname.new(Rails.root).join('spec', 'fixtures', 'brev', '000773452_X01')
    basic_file_object(path.join('000773452_X01_0001.jpg'))
    basic_file_object(path.join('000773452_X01_0002.jpg'))
  end

  after :all do
    delete_all_objects
  end

  it 'should add an OrderedInstance to the work' do
    work = LetterVolumeSplitter.create_jpg_oi(@work, @data, @prefix)
    expect(work.ordered_instance_types[:jpgs]).to_not be_nil
  end

  it 'should add an ordered instance containing two files' do
    work = LetterVolumeSplitter.create_jpg_oi(@work, @data, @prefix)
    files = work.ordered_instance_types[:jpgs].files
    expect(files.length).to eql 2
  end
end