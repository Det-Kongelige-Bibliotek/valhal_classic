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

  it 'should return a person name' do
    @service.parse_name(@xml).should eql 'Klee, Frederik'
  end

  it 'should split a personal name into a hash' do
    h = @service.hashify_personal_name('Klee, Frederik')
    h[:firstname].should eql 'Frederik'
    h[:lastname].should eql 'Klee'
  end

  it 'should return nil if there was no person data in the MODS XML' do
    p = @service.find_or_create_person(File.read("#{Rails.root}/spec/fixtures/mods_digitized_book_without_author.xml"))
    p.should be_nil
  end


end