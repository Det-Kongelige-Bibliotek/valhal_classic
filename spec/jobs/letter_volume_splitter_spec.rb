require 'spec_helper'

describe 'perform' do
  before :all do
    # create a sample work with a ordered instance
    # containing a basic file
    work = Work.new
    o = OrderedInstance.new
    bf = BasicFile.new
    @xml_path = Rails.root.join('spec', 'fixtures', 'brev', '001003574_000.xml')
    bf.add_file(File.new(@xml_path), true)
    o.files << bf
    work.add_instance(o)

    @content = LetterVolumeSplitter.perform(work.pid, bf.pid)
  end

  it 'should throw an error if called with an invalid work pid' do
    expect { LetterVolumeSplitter.perform('reallynotapid', '')}.to raise_error
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
    data[:note].should eql 'TIL SAMME'
    data[:needs_attention].should be_true
  end
end


describe 'transform' do

  before (:all) do
    file = File.new(Rails.root.join('spec', 'fixtures', 'brev', '001003574_000.xml').to_s)
    @result = LetterVolumeSplitter.transform(file)
  end

  it 'should return an xml doc' do
    @result.should be_a Nokogiri::XML::Document
  end
end