# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'uri'

describe "ordered_representations/show" do
  describe 'default tests' do
    before(:each) do
      #@ordered_representation = assign(:ordered_representation, stub_model(OrderedRepresentation))
      @ordered_representation = OrderedRepresentation.create!
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
    end
  end

  describe 'with tiff images' do
    before(:each) do
      @ordered_representation = OrderedRepresentation.create!
      @tiff = TiffFile.create!
      @tiff.add_file(ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.tif', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif")), '1')
      @tiff.save!
      @ordered_representation.files << @tiff
      @ordered_representation.save!
    end

    it 'renders the thumbnails' do
      # TODO fix the missing thumbnails
      pending "Missing thumbnails."
      visit ordered_representation_path(@ordered_representation)
      page.should have_xpath("//img[@src=\"#{thumbnail_url_ordered_representation_path @ordered_representation}?locale=en&pid=#{URI.encode_www_form_component(@tiff.pid)}\"]")
    end
  end
end
