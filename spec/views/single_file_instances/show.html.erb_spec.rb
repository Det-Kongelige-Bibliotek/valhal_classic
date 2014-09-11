# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "single_file_instances/show" do

  describe 'With a basic_files' do
    before(:each) do
      @work = Work.create!(:title => 'Test title')
      @single_file_instance = SingleFileInstance.create!
      @single_file_instance.ie = @work
      @work.instances << @single_file_instance
      uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'test.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @file = BasicFile.create!
      @file.add_file(uploaded_file, '1')
      @single_file_instance.files << @file
    end

    it 'should display the type of basic_files' do
      visit single_file_instance_path(@single_file_instance)

      page.should have_content(@file.file_type)
      page.should have_content(@single_file_instance.ie.title)
      @single_file_instance.ie.title.should eql('Test title')
    end

    after(:each) do
      delete_all_objects
    end
  end
end
