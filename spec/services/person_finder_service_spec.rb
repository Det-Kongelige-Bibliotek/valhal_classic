require 'spec_helper'

describe 'PersonFinderService' do

  before(:each) do
    @service = PersonFinderService
    @xml = File.read("#{Rails.root}/spec/fixtures/mods_digitized_book.xml")
    Person.new(lastname: 'Klee', firstname: 'Frederik').save
  end

  it 'should return a person object' do
    p = @service.find_or_create_person(@xml)
    p.should be_a(Person)
    p.name.should eql 'Frederik Klee'
  end

  it 'should return nil if there was no person data in the MODS XML' do
    p = @service.find_or_create_person(File.read("#{Rails.root}/spec/fixtures/mods_digitized_book_without_author.xml"))
    p.should be_nil
  end


end

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