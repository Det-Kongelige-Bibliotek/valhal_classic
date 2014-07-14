# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'works/show' do

  before(:each) do

    #Set up a dod_book_mock Work object to test with the view
    dod_book_mock = mock_model('Work', :workType => 'DOD eBook', :shelfLocator => '37,-376 8°', :title => 'Test title',
                  :subTitle => 'test subtitle', :has_author? => false, :has_concerned_person? => false,
                  :typeOfResource => 'DOD eBook', :publisher => 'test publisher', :originPlace => 'København',
                  :languageISO => 'da', :languageText => 'da', :subjectTopic => '', :dateIssued=> '',
                  :physicalExtent => '', :uuid => '', :has_ins? => false)

    assign(:work, dod_book_mock)

  end

  it 'should display shelf location for a work' do
    render
    rendered.to_s
    expect(rendered).to include('37,-376 8°')
  end

end
