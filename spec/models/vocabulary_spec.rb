require 'spec_helper'

describe Vocabulary do

  after :each do
    delete_all_objects
  end

  it_behaves_like 'ActiveModel'

  it 'should be createable' do
    v = Vocabulary.new(name: 'fish')
    v.name.should eql 'fish'
  end

  it 'should respond to all' do
    Vocabulary.respond_to?(:all).should be_true
  end

  it 'should be updateable' do
    v = Vocabulary.new(name: 'fish')
    v.update(name: 'fishies')
    v.name.should eql 'fishies'
  end

  it 'should be findable by name' do
    v = Vocabulary.create(name: 'fish')
    Vocabulary.with(:name, 'fish').should eql v
  end

  it 'should be deletable' do
    v = Vocabulary.create(name: 'fish')
    v.delete
    Vocabulary.with(:name, 'fish').should be_nil
  end

  it 'should contain entries' do
    v = Vocabulary.create(name: 'fish')
    e = VocabularyEntry.create(vocabulary: v, name: 'mackerel', description: 'A pelagic fish, typically from the family Scombridae')
    v.entries.include?(e).should be_true
    e.vocabulary.should eql v
  end

  it 'should be possible to update entries' do
    details = {name: 'Mackerel', description: 'A pelagic fish'}
    e = VocabularyEntry.create(details)
    v = Vocabulary.create(name: 'fish', entries: [e.to_hash])
    updated = e.to_params.merge({'description' => 'A cuniform fish'})
    v.entries=[updated]
    v.entries.length.should eql 1
    v.entries.first.description.should eql 'A cuniform fish'
  end

  it 'has a to_hash method' do
    v = Vocabulary.create(name: 'fish')
    v.to_hash.keys.should include(:name)
  end

  it 'should be countable' do
    Vocabulary.create(name: 'fish')
    Vocabulary.create(name: 'invertebrates')
    Vocabulary.count.should eql 2
  end

  it 'should ensure uniqueness of names on save' do
    Vocabulary.new(name: 'fish').save.should be_true
    v = Vocabulary.new(name: 'fish')
    v.save.should be_false
    v.errors.messages.length.should be > 0
  end

  it 'should ensure uniqueness of names on create' do
    Vocabulary.create(name: 'fish').should be_true
    Vocabulary.create(name: 'fish').should be_false
  end
end

