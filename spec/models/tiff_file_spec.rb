# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TiffFile do
  subject { BasicFile.new }
  it_behaves_like 'a preservable element'
  it_behaves_like 'an element with administrative metadata'

  context "with a tiff basic_files" do
    before do
      @uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'test.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"), head: "Content-Disposition: form-data; name=\"basic_files[tiff_file][]\"; filename=\"arre1fm005.tif\"\r\nContent-Type: image/tiff\r\n")
    end

    it "should have shorthand for adding a basic_files just like a basic basic_files" do
      file = TiffFile.create
      file.add_file(@uploaded_file, '1').should be_true
      file.save.should be_true
    end

    it "should create a thumbnail when the tiff image is loaded" do
      file = TiffFile.create
      file.add_file(@uploaded_file, '1').should be_true
      file.save!

      file.thumbnail.should_not be_nil
      file.has_thumbnail?.should be_true
    end

    it "should not have a thumbnail before any tiff image has been loaded" do
      file = TiffFile.create
      file.has_thumbnail?.should be_false
    end
  end

  after :all do
    TiffFile.all.each { |tf| tf.delete }
  end
end
