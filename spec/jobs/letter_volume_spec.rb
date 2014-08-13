require 'spec_helper'

describe 'Perform' do

  before :each do
    @fixtures_path = Rails.root.join('spec', 'fixtures', 'brev')

  end

  it 'should throw an Exception if supplied with a mismatching sysnum' do
    expect {
      LetterVolumeIngest.perform(@fixtures_path.join('001003574_000.xml').to_s,
                                 @fixtures_path.join('001003572_000.pdf').to_s)
    }.to raise_error
  end

  it 'should create a work for the volume when no volume exists' do
    LetterVolumeIngest.perform(@fixtures_path.join('001003574_000.xml').to_s,
                               @fixtures_path.join('001003574_000.pdf').to_s)
    Work.all.size.should be > 0
  end

  it 'should create an instance for the volume' do
    pending 'implement me!'
  end
end

describe 'parse_sysnum' do
  it 'should parse the sysnum from a string containing a file path' do
    sysnum = LetterVolumeIngest.parse_sysnum('001003574_000.pdf')
    sysnum.should eql '001003574'
  end
end