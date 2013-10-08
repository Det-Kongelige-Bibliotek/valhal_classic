# -*- encoding : utf-8 -*-
require 'spec_helper'

describe TeiFile do

  subject { BasicFile.new }
  it_behaves_like 'a preservable element'

  before(:all) do
    @uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'test.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
  end

  context 'with a Tei file' do
    it 'should have shorthand for adding a file just like a basic file' do
      file = TeiFile.create
      file.add_file(@uploaded_file).should be_true
      file.save.should be_true
    end
  end

  context 'metadata' do
    it 'should contain TEI version in file type' do
      version = 'This TEI file has version P5'
      tei = TeiFile.create(:tei_version => version)
      tei.file_type.to_s.include?(version).should be_true
    end

    it 'should contain the mimetype in the file type if no TEI version is defined' do
      version = 'This TEI file has version P5'
      tei = TeiFile.create!
      tei.add_file(@uploaded_file).should be_true
      tei.file_type.to_s.include?(version).should be_false
      tei.file_type.to_s.include?(@uploaded_file.content_type).should be_true
    end

    it 'should be possible to add a version afterwards' do
      version = 'This TEI file has version P5'
      tei = TeiFile.create!
      tei.add_file(@uploaded_file).should be_true
      tei.file_type.to_s.include?(version).should be_false
      tei.file_type.to_s.include?(@uploaded_file.content_type).should be_true

      tei.tei_version = version
      tei.save!
      tei.file_type.to_s.include?(version).should be_true
      tei.file_type.to_s.include?(@uploaded_file.content_type).should be_false
    end
  end

  after :all do
    TeiFile.all.each { |tf| tf.delete }
  end
end
