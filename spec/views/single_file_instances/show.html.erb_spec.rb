# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "single_file_instances/show" do
  describe 'default test' do
    before(:each) do
      @single_file_instance = SingleFileInstance.create!
      # @single_file_instance = assign(:single_file_instance, stub_model(SingleFileInstance))
    end

  end

  describe 'With a basic_files' do
    before(:each) do
      @single_file_instance = SingleFileInstance.create!
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'test.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @file = BasicFile.create!
      @file.add_file(uploaded_file, '1')
      @single_file_instance.files << @file
    end

    it 'should display the type of basic_files' do
      visit single_file_representation_path(@single_file_instance)

      page.should have_content(@file.file_type)
    end
  end
end
