require 'spec_helper'

describe Vocabulary do

  after :each do
    Ohm.redis.call('flushdb')
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
    Vocabulary.find(name: 'fish').first.should eql v
  end

  it 'should be deletable' do
    v = Vocabulary.create(name: 'fish')
    v.delete
    Vocabulary.find(name: 'fish').first.should be_nil
  end

  it 'should contain entries' do
    v = Vocabulary.create(name: 'fish')
    e = VocabularyEntry.create(vocabulary: v, name: 'mackerel', description: 'A pelagic fish, typically from the family Scombridae')
    v.entries.include?(e).should be_true
    e.vocabulary.should eql v
  end

  it 'should be countable' do
    Vocabulary.create(name: 'fish')
    Vocabulary.create(name: 'invertebrates')
    Vocabulary.count.should eql 2
  end
end

