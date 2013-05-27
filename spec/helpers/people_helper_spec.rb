# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PeopleHelper do

  describe '#add_portrait' do
    before(:each) do
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.now.nsec.to_s)
      @image_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should not require metadata for creating the portrait' do
      @person.concerning_manifestations.length.should == 0
      add_portrait(@image_file, {}, {}, @person).should be_true

      #reload person
      person = Person.find(@person.pid)

      person.concerning_manifestations.length.should == 1
      person.concerning_manifestations.last.kind_of?(Work).should be_true
      person.concerning_manifestations.last.title.should include(@person.name)
      person.concerning_manifestations.last.work_type.should == 'PersonPortrait'
      person.concerning_manifestations.last.representations.length.should == 1
      person.concerning_manifestations.last.representations.first.kind_of?(SingleFileRepresentation).should be_true
      person.concerning_manifestations.last.representations.first.label.should include(SingleFileRepresentation.to_s)
      person.concerning_manifestations.last.representations.first.files.length.should == 1
      person.concerning_manifestations.last.representations.first.files.first.kind_of?(BasicFile).should be_true
    end

    it 'should allow overloading of metadata when creating the portrait' do
      @person.concerning_manifestations.length.should == 0
      representation_label = 'A non-default label for the representation' + Time.now.nsec.to_s
      portrait_title = 'A non-default title for the portrait ' + Time.now.nsec.to_s
      portrait_work_type = 'A non-defeault work type for the portrait' + Time.now.nsec.to_s
      add_portrait(@image_file, {:label => representation_label}, {:title => portrait_title, :work_type => portrait_work_type}, @person).should be_true

      #reload person
      person = Person.find(@person.pid)

      person.concerning_manifestations.length.should == 1
      person.concerning_manifestations.last.kind_of?(Work).should be_true
      person.concerning_manifestations.last.title.should == portrait_title
      person.concerning_manifestations.last.work_type.should == portrait_work_type
      person.concerning_manifestations.last.representations.length.should == 1
      person.concerning_manifestations.last.representations.first.label.should == representation_label
    end
  end

  describe '#add_person_description' do
    before(:each) do
      @person = Person.create(:firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.now.nsec.to_s)
      @tei_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @non_tei_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should not require metadata for creating the person description' do
      @person.concerning_manifestations.length.should == 0
      add_person_description({}, @tei_file, {}, {}, @person).should be_true

      #reload person
      person = Person.find(@person.pid)

      person.concerning_manifestations.length.should == 1
      person.concerning_manifestations.last.kind_of?(Work).should be_true
      person.concerning_manifestations.last.title.should include(@person.name)
      person.concerning_manifestations.last.work_type.should == 'PersonDescription'
      person.concerning_manifestations.last.representations.length.should == 1
      person.concerning_manifestations.last.representations.first.kind_of?(SingleFileRepresentation).should be_true
      person.concerning_manifestations.last.representations.first.label.should include(SingleFileRepresentation.to_s)
      person.concerning_manifestations.last.representations.first.files.length.should == 1
      person.concerning_manifestations.last.representations.first.files.first.kind_of?(TeiFile).should be_true
      person.concerning_manifestations.last.representations.first.files.first.tei_version.blank?.should be_true
    end

    it 'should allow overloading of metadata when creating the person description' do
      @person.concerning_manifestations.length.should == 0
      tei_metadata = 'P5'
      representation_label = 'A non-default label for the representation ' + Time.now.nsec.to_s
      person_description_title = 'A non-default title for the person description ' + Time.now.nsec.to_s
      person_description_work_type = 'A non-defeault work type for the person description ' + Time.now.nsec.to_s
      add_person_description({:tei_version => tei_metadata},
                             @tei_file,
                             {:label => representation_label},
                             {:title => person_description_title, :work_type => person_description_work_type},
                             @person).should be_true

      #reload person
      person = Person.find(@person.pid)

      person.concerning_manifestations.length.should == 1
      person.concerning_manifestations.last.kind_of?(Work).should be_true
      person.concerning_manifestations.last.title.should == person_description_title
      person.concerning_manifestations.last.work_type.should == person_description_work_type
      person.concerning_manifestations.last.representations.length.should == 1
      person.concerning_manifestations.last.representations.first.label.should == representation_label
      person.concerning_manifestations.last.representations.first.files.length.should == 1
      person.concerning_manifestations.last.representations.first.files.first.kind_of?(TeiFile).should be_true
      person.concerning_manifestations.last.representations.first.files.first.tei_version.should == tei_metadata
    end

    it 'should not allow non-tei files as person description' do
      @person.concerning_manifestations.length.should == 0
      add_person_description({}, @non_tei_file, {}, {}, @person).should be_false

      #reload person
      person = Person.find(@person.pid)

      person.concerning_manifestations.length.should == 0
    end
  end
end