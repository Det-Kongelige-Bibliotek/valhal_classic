require 'spec_helper'

describe 'personal name' do

  it 'should retrieve the personal names ' do
    f = File.new(Rails.root.join('spec', 'fixtures', 'mods_digitized_book_with_2_authors.xml'))
    mods = Datastreams::Mods.from_xml(f)
    expect(mods.person.name).to eql ['Klee, Frederik', 'Laudrup, Henrik']
  end

  it 'should retrieve the corporate names ' do
    f = File.new(Rails.root.join('spec', 'fixtures', 'mods_digitised_corp_author.xml'))
    mods = Datastreams::Mods.from_xml(f)
    expect(mods.corporate.name).to eql ['Børnehjemmet "Godthaab"']
  end

  it 'should retrieve the primary name' do
    f = File.new(Rails.root.join('spec', 'fixtures', 'mods_digitized_book_with_2_authors.xml'))
    mods = Datastreams::Mods.from_xml(f)
    expect(mods.primary.name).to eql ['Klee, Frederik']
  end

end