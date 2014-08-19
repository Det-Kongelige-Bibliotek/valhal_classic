require 'spec_helper'

describe LetterVolumeIngest do

  after(:all) do
    Work.all.each {|w| w.delete }
  end

  describe 'Perform' do

    before :each do
      @fixtures_path = Rails.root.join('spec', 'fixtures', 'brev')
    end

    it 'should throw an Exception if supplied with a mismatching sysnum' do
      expect {
        LetterVolumeIngest.perform(@fixtures_path.join('001003574_000.xml').to_s,
                                   @fixtures_path.join('001003572_000.pdf').to_s, '')
      }.to raise_error
    end

    it 'should create a work for the volume when no volume exists' do
      LetterVolumeIngest.perform(@fixtures_path.join('001003574_000.xml').to_s,
                                 @fixtures_path.join('001003574_000.pdf').to_s, '')
      Work.all.size.should be > 0
    end

  end

  describe 'parse_sysnum' do
    it 'should parse the sysnum from a string containing a file path' do
      sysnum = LetterVolumeIngest.parse_sysnum('001003574_000.pdf')
      sysnum.should eql '001003574'
    end
  end

  describe 'find_or_create_work' do
    it 'should create a work if no existing work is found' do
      w = LetterVolumeIngest.find_or_create_work('123456')
      w.should be_a Work
      w.sysnum.should eql '123456'
    end

    it 'should find an existing work if there is one' do
      w = Work.new
      w.identifier= [{'displayLabel' => 'sysnum', 'value' => '1234'}]
      w.save.should be_true
      w2 = LetterVolumeIngest.find_or_create_work('1234')
      w2.pid.should eql w.pid
    end
  end

end

describe LetterVolumeFile do
  before :each do
    @path = Rails.root.join('spec', 'fixtures', 'brev')
  end

  it 'should parse a sysnum from a file path' do
    file = LetterVolumeFile.new(@path.join('001003574_000.xml'))
    file.sysnum.should eql '001003574'
  end

  it 'should throw an error if given a path without an underscore' do
    expect {
      LetterVolumeFile.new(@path.join('001003574000.xml'))
    }.to raise_error
  end

  it 'should indicated whether the file is multivolume or not' do
    file = LetterVolumeFile.new(@path.join('001003574_000.xml'))
    file.multivolume?.should be_false
    file2 = LetterVolumeFile.new(@path.join('000773452_X01.xml'))
    file2.multivolume?.should be_true
  end

  it 'should give an index for ordering the file in an array' do
    file = LetterVolumeFile.new(@path.join('000773452_X01.xml'))
    file.index.should eql 0
  end

  it 'should give the position of the file in the work' do
    file = LetterVolumeFile.new(@path.join('001003574_000.pdf'))
    file.number.should eql 0
  end
end