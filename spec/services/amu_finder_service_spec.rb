require 'spec_helper'

describe 'AMUFinderService' do

  before(:all) do
    @service = AMUFinderService
    @xml = File.read("#{Rails.root}/spec/fixtures/mods_digitized_book.xml")
    @amu = AuthorityMetadataUnit.create(:type=>'agent/person', :value=>'Klee, Frederik')
  end

  after(:all) do
    AuthorityMetadataUnit.all.each do |amu|
      amu.destroy
    end
  end

  it 'should return a person object' do
    agents = @service.find_agents_with_relation_from_mods(@xml)
    agents.should be_a(Hash)
    agents.should_not be_empty
    agents.size.should == 1
    amu = agents.keys.first
    amu.should be_a(AuthorityMetadataUnit)
    amu.type.should == @amu.type
    amu.value.should == @amu.value
    amu.pid.should == @amu.pid
    rel = agents.values.first
    rel.should be_a(String)
    rel.should == 'Author'
  end

  it 'should return nil if there was no person data in the MODS XML' do
    p = @service.find_agents_with_relation_from_mods(File.read("#{Rails.root}/spec/fixtures/mods_digitized_book_without_author.xml"))
    p.should be_empty
  end

end

=begin
describe 'Name class' do

  it 'should create a corporate name object' do
    xml = File.read("#{Rails.root}/spec/fixtures/mods_digitised_corp_author.xml")
    name = Name.new(xml)
    name.text.should eql 'Børnehjemmet "Godthaab"'
    name.type.should eql 'corporate'
    name.to_hash[:firstname].should be_nil
    name.to_hash[:lastname].should eql 'Børnehjemmet "Godthaab"'
  end

  it 'should create a personal name object' do
    xml = File.read("#{Rails.root}/spec/fixtures/mods_digitized_book.xml")
    name = Name.new(xml)
    name.text.should eql 'Klee, Frederik'
    name.type.should eql 'personal'
    name.to_hash[:firstname].should eql 'Frederik'
    name.to_hash[:lastname].should eql 'Klee'
  end

end
=end
