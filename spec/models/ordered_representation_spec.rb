# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'support/representation_spec_helper'

describe OrderedRepresentation do
  include RepresentationSpecHelper

  subject { OrderedRepresentation.new }
  it_behaves_like 'a preservable element'


  it 'should have a datastream named descMetadata ' do
    subject.descMetadata.should_not be_nil
  end

  it 'should have a datastream named rightsMetadata' do
    subject.rightsMetadata.should_not be_nil
  end

  it 'should have a datastream named provenanceMetadata' do
    subject.provenanceMetadata.should_not be_nil
  end

  it 'should have a datastream names techMetadata' do
    subject.techMetadata.should_not be_nil
  end

  describe '#basic_files' do
    context 'with multiple BasicFiles' do
      let(:default_files) do
        array = []
        (1..3).each do
          basic_file = BasicFile.new
          uploaded_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
          basic_file.add_file(uploaded_file, nil)
          basic_file.save!
          array << basic_file
        end
        array
      end

      it 'should be able to have a association with BasicFiles' do
        basic_files = default_files
        subject.files << basic_files
        subject.files.should == basic_files
      end

      it 'should be able to be saved with a association to BasicFiles' do
        basic_files = default_files
        subject.files << basic_files
        subject.save.should be_true
      end

      it 'should be able to retrieve BasicFiles from a saved representation' do
        basic_files = default_files
        subject.files << basic_files
        subject.save
        pid = subject.pid
        def_rep = subject.class.find(pid)
        def_rep.files.should == basic_files
      end
    end
  end
end
