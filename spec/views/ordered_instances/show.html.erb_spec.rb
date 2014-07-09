# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'uri'

describe "ordered_instances/show" do
  describe 'default tests' do
    before(:each) do
      #@ordered_instance = assign(:ordered_instance, stub_model(OrderedInstance))
      @ordered_instance = OrderedInstance.create!
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
  end

  describe 'with tiff images' do
    before(:each) do
      @ordered_instance = OrderedInstance.create!
      @tiff = TiffFile.create!
      @tiff.add_file(ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.tif', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif")), '1')
      @tiff.save!
      @ordered_instance.files << @tiff
      @ordered_instance.save!
    end

    it 'renders the thumbnails' do
      # TODO fix the missing thumbnails
      pending "Missing thumbnails."
      visit ordered_instance_path(@ordered_instance)
      page.should have_xpath("//img[@src=\"#{thumbnail_url_ordered_instance_path @ordered_instance}?locale=en&pid=#{URI.encode_www_form_component(@tiff.pid)}\"]")
    end
  end
end
