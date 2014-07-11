# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DisseminationService do

  before (:all) do
    mods = File.open('spec/fixtures/mods_digitized_book.xml').read
    @url = "http://www.kb.dk/e-mat/dod/404.pdf"
    @work = Work.create(title: "test-#{Time.now.nsec.to_s}", workType: "test")
    @work.descMetadata.content = mods
    @work.save!
  end

  it 'should have a work, which can be disseminated' do
    disseminate(@work, {'fileUri' => @url}, DISSEMINATION_TYPE_BIFROST_BOOKS)
  end

  it 'should raise an error, if wrong type is given' do
    bad_type = "THIS IS AN ERROR"
    begin
      disseminate(@work, {'fileUri' => @url}, bad_type)
      fail "SHOULD THROW AN ERROR"
    rescue => e
      e.should be_kind_of ArgumentError
      e.message.should match bad_type
      # success
    end
  end

  it 'should raise an error, if no file uri is given' do
    begin
      disseminate(@work, {}, DISSEMINATION_TYPE_BIFROST_BOOKS)
      fail "SHOULD THROW AN ERROR"
    rescue => e
      e.should be_kind_of ArgumentError
      # success
    end
  end

  it 'should create a valid JSON instance of a Work' do
    json = create_message_for_dod_book(@work, {'fileUri' => @url})
    json_hash = JSON.parse(json)
    json_hash['MODS'].should_not be_empty
  end

  it 'should create JSON containing MODS with two authors for a MODS XML with two authors' do
    pending "Fix for xpath or use css selector instead"
    mods = File.open('spec/fixtures/mods_digitized_book_with_2_authors.xml').read
    url = "http://www.kb.dk/e-mat/dod/404.pdf"
    work = Work.create(title: "test-#{Time.now.nsec.to_s}", workType: "test")
    work.descMetadata.content = mods
    work.save!

    json_string = create_message_for_dod_book(work, {'fileUri' => url})
    json = JSON.parse(json_string)
    mods_xml = Nokogiri::XML.parse(json['MODS'])

    #puts mods_xml.xpath('/')
    #TODO fix this test
    #expect(mods_xml.xpath('count(//namePart)')).to eq 2

  end

  after (:all) do
    BasicFile.all.each { |file| file.delete }
    Work.all.each { |w| w.delete }
    SingleFileInstance.all.each { |ins| ins.delete}
  end

end
