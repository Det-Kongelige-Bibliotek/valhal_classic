# -*- encoding : utf-8 -*-
require 'spec_helper'

describe DisseminationService do

  before (:each) do
    mods = File.open('spec/fixtures/mods_digitized_book.xml').read
    @url = "http://www.kb.dk/e-mat/dod/404.pdf"
    @work = Work.new
    @work.descMetadata.content = mods
    @work.save!
  end

  it 'should have a work, which can be disseminated' do
    disseminate(@work, {'fileUri' => @url}, DISSEMINATION_TYPE_BIFROST_BOOKS)
  end

  after (:all) do
    BasicFile.all.each { |file| file.delete }
    Work.all.each { |w| w.delete }
    SingleFileRepresentation.all.each { |rep| rep.delete}
  end

end
