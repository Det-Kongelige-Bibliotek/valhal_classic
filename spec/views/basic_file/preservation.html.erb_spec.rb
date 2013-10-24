# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "basic_files/preservation" do
  describe 'with capybara' do
    before(:each) do
      @file = create_basic_file(nil)
    end
    it 'should contain the default information about the file.' do
      visit preservation_basic_file_path(@file)

      page.has_text?(@file.preservation_profile)
      page.has_text?(@file.preservation_state)
      page.has_text?(@file.preservation_modify_date)
    end

    it 'has links to other parts' do
      visit preservation_basic_file_path(@file)

      page.has_link?('Show file', basic_file_path(@file)).should be_true
      page.has_link?('Download file', download_basic_file_path(@file)).should be_true
      page.has_link?('Preservation settings', preservation_basic_file_path(@file)).should be_true
    end

    it 'should be possible to download the file' do
      visit preservation_basic_file_path(@file)

      click_on 'Download file'
      page.response_headers['Content-Disposition'].to_s.should include @file.original_filename
      page.response_headers['Content-Type'].should eq @file.mime_type
      page.response_headers['Content-Length'].should eq @file.size.to_s
    end
  end

end