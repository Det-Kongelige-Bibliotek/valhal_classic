# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "basic_files/show" do
  describe 'default' do
    before(:each) do
      @file = assign(:file, stub_model(BasicFile))
    end

    it 'should be possible to render' do
      render
    end
  end

  describe 'with capybara' do
    before(:each) do
      @file = create_basic_file(nil)
    end
    it 'should contain the default information about the file.' do
      visit basic_file_path(@file)

      page.has_text?(@file.inspect)
    end

    it 'has links to other parts' do
      visit basic_file_path(@file)

      page.has_link?('Show file', basic_file_path(@file)).should be_true
      page.has_link?('Download file', download_basic_file_path(@file)).should be_true
      page.has_link?('Preservation settings', preservation_basic_file_path(@file)).should be_true
    end
  end
end