require 'spec_helper'

describe Person do
  after :all do
    AuthorityMetadataUnit.all.each do |amu|
      amu.delete
    end
  end

  it 'should be possible to create a person with values in all fields' do
    p = Person.create(:firstName => 'test', :lastName =>'testsen', :dateOfBirth => '1900-01-01', :dateOfDeath => '2000-01-01')
    p.should_not be_nil
    p.type.should == 'agent/person'
    p.firstName.should == 'test'
    p.lastName.should == 'testsen'
    p.dateOfBirth.should == '1900-01-01'
    p.dateOfDeath.should == '2000-01-01'
  end

  describe "#delete" do
    before :each do
      @p = Person.create!(:firstName => 'test', :lastName =>'testsen', :dateOfBirth => '1900-01-01', :dateOfDeath => '2000-01-01')

    end

    it 'should be possible to delete an AMU' do
      @p.save.should be_true
      @p.delete.should be_true
    end
  end

  describe "#update" do
    it 'should be possible to update all fields' do
      p = Person.create(:firstName => 'test', :lastName =>'testsen', :dateOfBirth => '1900-01-01', :dateOfDeath => '2000-01-01')

      p.firstName = 'test2'
      p.lastName = 'testsen2'
      p.dateOfBirth = '1900-02-02'
      p.dateOfDeath = '2000-02-02'

      p.save
      p.reload

      p.firstName.should == 'test2'
      p.lastName.should == 'testsen2'
      p.dateOfBirth.should == '1900-02-02'
      p.dateOfDeath.should == '2000-02-02'
    end
  end

  describe 'from_string' do
    it 'should create a new person when no matching person exists' do
      joyce = Person.from_string('Joyce, James')
      expect(joyce.firstName).to eql 'James'
      expect(joyce.lastName).to eql 'Joyce'
    end

    it 'should find a matching person when that person exists' do
      joyce = Person.create(firstName: 'James', lastName: 'Joyce')
      p = Person.from_string('Joyce, James')
      expect(p.pid).to eql joyce.pid
    end
  end

  describe 'person_search_fields' do
    it 'should return a hash mapping solr fields to values' do
      fields = Person.person_search_fields({lastName: 'James'})
      expect(fields.keys.first).to eql 'person_lastName_ssi'
    end
  end
end

