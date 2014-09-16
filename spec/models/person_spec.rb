require 'spec_helper'

describe 'from_string' do
  after :all do
    delete_all_objects
  end

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