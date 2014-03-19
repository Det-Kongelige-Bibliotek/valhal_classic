# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DisseminationService do

  before (:all) do
    mods = File.open('spec/fixtures/mods_digitized_book.xml').read
    @url = "http://www.kb.dk/e-mat/dod/404.pdf"
    @work = Work.create(title: "test-#{Time.now.nsec.to_s}", work_type: "test")
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

  after (:all) do
    BasicFile.all.each { |file| file.delete }
    Work.all.each { |w| w.delete }
    SingleFileRepresentation.all.each { |rep| rep.delete}
  end

end
