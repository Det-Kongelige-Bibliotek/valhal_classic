require 'spec_helper'

describe VocabulariesController do

  after :all do
    delete_all_objects
  end

  it 'should create a new vocabulary with entries' do
    params = {name: 'Fish', entries: [
        [{ 'name' => 'mackerel', 'description' => 'A pelagic fish'},
        { 'name' => 'pollock', 'description' => 'An artistic fish'}]
    ] }
    expect {
      post :create, vocabulary: params
    }.to change(Vocabulary, :count).by(1)
    Vocabulary.first.entries.length.should eql 2
  end
end