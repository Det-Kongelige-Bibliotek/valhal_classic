require 'spec_helper'

describe LetterVolumeIngest do

  after(:all) do
    Work.all.each {|w| w.delete }
    OrderedInstance.all.each {|w| w.delete }
    BasicFile.all.each {|w| w.delete }
  end

  describe 'Perform' do

    before :all do
      @fixtures_path = Rails.root.join('spec', 'fixtures', 'brev')
      LetterVolumeIngest.perform(@fixtures_path.join('001003574_000.xml').to_s,
                                 @fixtures_path.join('001003574_000.pdf').to_s,
                                 @fixtures_path.join('001003574_000').to_s)
      @work = Work.find(sysnum_si: '001003574').first
    end

    it 'should throw an Exception if supplied with a mismatching sysnum' do
      expect {
        LetterVolumeIngest.perform(@fixtures_path.join('001003574_000.xml').to_s,
                                   @fixtures_path.join('001003572_000.pdf').to_s, '')
      }.to raise_error
    end

    it 'should create a work for the volume when no volume exists' do
      Work.all.size.should be > 0
    end

    it 'should create a Person object for the author' do
      pending 'implement me!!!'
      author = Work.author
      expect(author).to_not be_nil
    end

    it 'should create ordered instances for pdfs, jpgs and xml files' do
      @work.ordered_instance_types.should include :pdfs
      @work.ordered_instance_types.should include :teis
      @work.ordered_instance_types.should include :jpgs
      jpgs = @work.ordered_instance_types[:jpgs]
      jpgs.files.length.should eql 4
    end

    it 'should have a work type Book' do
      @work.workType.should eql 'Book'
    end

  end

  describe 'transform' do
    it 'should return a file object' do
      path = Rails.root.join('spec', 'fixtures', 'brev').join('001003574_000.xml')
      result = LetterVolumeIngest.transform(path)
      result.should be_a File
    end
  end

  describe 'multiple volumes' do
    it 'shuld have two works with same sysnum' do
      @fixtures_path = Rails.root.join('spec', 'fixtures', 'brev')
      LetterVolumeIngest.perform(@fixtures_path.join('000773452_X02.xml').to_s,
                                 @fixtures_path.join('000773452_X02.pdf').to_s,
                                 @fixtures_path.join('000773452_X02').to_s)
      LetterVolumeIngest.perform(@fixtures_path.join('000773452_X01.xml').to_s,
                                 @fixtures_path.join('000773452_X01.pdf').to_s,
                                 @fixtures_path.join('000773452_X01').to_s)
      works = Work.find(sysnum_si: '000773452')
      works.size.should == 1;

      work = works.first
      work.ordered_instances == 3

    end
  end

  describe 'fetch_jpgs' do
    it 'should return an array of jpgs' do
      fixtures_path = Rails.root.join('spec', 'fixtures', 'brev')
      jpgs = LetterVolumeIngest.fetch_jpgs(fixtures_path.join('001003574_000'))
      jpgs.should be_an Array
      jpgs.length.should eql 4
      jpgs.first.should be_a String
    end
  end

  describe 'find_or_create_work' do
    before :all do
      @work = LetterVolumeIngest.find_or_create_work('000773452')
    end

    it 'should create a work if no existing work is found' do
      @work.should be_a Work
      @work.sysnum.should eql '000773452'
    end

    it 'should create an author for that work' do
      @work.hasAuthor.first.should be_a Person
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