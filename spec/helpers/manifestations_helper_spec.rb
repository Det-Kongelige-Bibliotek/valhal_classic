# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ManifestationsHelper do

  describe '#add_single_tei_rep' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @tei_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @other_xml_file = ActionDispatch::Http::UploadedFile.new(filename: 'samlede_skrifter_bd_1_arrebo_mods_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/samlede_skrifter_bd_1_arrebo_mods_sample.xml"))
      @non_xml_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should be possible with a TEI basic_files' do
      add_single_tei_rep({}, @tei_file, {}, @manifestation).should be_true

      @manifestation.single_file_reps.length.should == 1
      @manifestation.single_file_reps.first.kind_of?(SingleFileRepresentation).should be_true
      @manifestation.single_file_reps.first.files.length.should == 1
      @manifestation.single_file_reps.first.files.first.kind_of?(TeiFile).should be_true
      @manifestation.single_file_reps.first.files.first.original_filename.should == @tei_file.original_filename
    end

    it 'should be possible with a TEI basic_files with metadata' do
      version = 'p5'
      label = 'Tei p5 test label'
      add_single_tei_rep({:tei_version => version}, @tei_file, {:label => label}, @manifestation).should be_true

      @manifestation.single_file_reps.length.should == 1
      @manifestation.single_file_reps.first.kind_of?(SingleFileRepresentation).should be_true
      @manifestation.single_file_reps.first.files.length.should == 1
      @manifestation.single_file_reps.first.files.first.kind_of?(TeiFile).should be_true
      @manifestation.single_file_reps.first.files.first.original_filename.should == @tei_file.original_filename

      @manifestation.single_file_reps.first.label.should == label
      @manifestation.single_file_reps.first.files.first.tei_version.should == version
    end

    # TODO this is probably not the intended behavior (non-tei xml basic_files accepted as tei basic_files.)
    it 'should be possible with a XML basic_files' do
      add_single_tei_rep({}, @other_xml_file, {}, @manifestation).should be_true

      @manifestation.single_file_reps.length.should == 1
      @manifestation.single_file_reps.first.kind_of?(SingleFileRepresentation).should be_true
      @manifestation.single_file_reps.first.files.length.should == 1
      @manifestation.single_file_reps.first.files.first.kind_of?(TeiFile).should be_true
      @manifestation.single_file_reps.first.files.first.original_filename.should == @other_xml_file.original_filename
    end

    it 'should not be possible with a non-xml basic_files' do
      add_single_tei_rep({}, @non_xml_file, {}, @manifestation).should be_false

      @manifestation.single_file_reps.length.should == 0
    end
  end

  describe '#add_single_file_rep' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @tei_file = ActionDispatch::Http::UploadedFile.new(filename: 'aarrebo_tei_p5_sample.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarrebo_tei_p5_sample.xml"))
      @octet_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'octet-stream', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should be possible with a TEI basic_files' do
      add_single_file_rep(@tei_file, {}, nil, @manifestation).should be_true

      @manifestation.single_file_reps.length.should == 1
      @manifestation.single_file_reps.first.kind_of?(SingleFileRepresentation).should be_true
      @manifestation.single_file_reps.first.files.length.should == 1
      @manifestation.single_file_reps.first.files.first.kind_of?(BasicFile).should be_true
      @manifestation.single_file_reps.first.files.first.original_filename.should == @tei_file.original_filename
    end

    it 'should be possible with an binary basic_files' do
      add_single_file_rep(@octet_file, {}, nil, @manifestation).should be_true

      @manifestation.single_file_reps.length.should == 1
      @manifestation.single_file_reps.first.kind_of?(SingleFileRepresentation).should be_true
      @manifestation.single_file_reps.first.files.length.should == 1
      @manifestation.single_file_reps.first.files.first.kind_of?(BasicFile).should be_true
      @manifestation.single_file_reps.first.files.first.original_filename.should == @octet_file.original_filename
    end

    it 'should not allow non-basic_files to be added' do
      add_single_file_rep('TEI basic_files', {}, nil, @manifestation).should be_false
      @manifestation.single_file_reps.length.should == 0
    end
  end

  describe '#add_tiff_order_rep' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @tiff1 = ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.xml', type: 'image/tif', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      @tiff2 = ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm002.xml', type: 'image/tif', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm002.tif"))
      @other_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'octet-stream', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should be possible with a single tiff basic_files' do
      add_ordered_file_rep([@tiff1], {}, @manifestation).should be_true

      @manifestation.ordered_reps.length.should == 1
      @manifestation.ordered_reps.first.kind_of?(OrderedRepresentation).should be_true
      @manifestation.ordered_reps.first.files.length.should == 1
      @manifestation.ordered_reps.first.files.first.kind_of?(TiffFile).should be_true
      @manifestation.ordered_reps.first.files.first.original_filename.should == @tiff1.original_filename
    end

    it 'should be possible with several tiff basic_files' do
      add_ordered_file_rep([@tiff1, @tiff2], {}, @manifestation).should be_true

      @manifestation.ordered_reps.length.should == 1
      @manifestation.ordered_reps.first.kind_of?(OrderedRepresentation).should be_true
      @manifestation.ordered_reps.first.files.length.should == 2
      @manifestation.ordered_reps.first.files.first.kind_of?(TiffFile).should be_true
      @manifestation.ordered_reps.first.files.first.original_filename.should == @tiff1.original_filename
      @manifestation.ordered_reps.first.files.last.kind_of?(TiffFile).should be_true
      @manifestation.ordered_reps.first.files.last.original_filename.should == @tiff2.original_filename
    end

    it 'should not be possible with an binary basic_files' do
      add_ordered_file_rep([@other_file], {}, @manifestation).should be_false

      @manifestation.ordered_reps.length.should == 0
    end

    it 'should validate the structmap' do
      add_order_rep([@tiff1, @tiff2], {}, @manifestation).should be_true

      structmap = @manifestation.representations.last.techMetadata.ng_xml.to_s
      structmap.index(@tiff1.original_filename).should be < structmap.index(@tiff2.original_filename)
    end
  end

  describe '#add_order_rep' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @tiff = ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.xml', type: 'image/tif', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      @other_file = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'octet-stream', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should be possible with two different kind of basic_files' do
      add_order_rep([@tiff, @other_file], {}, @manifestation).should be_true

      @manifestation.ordered_reps.length.should == 1
      @manifestation.ordered_reps.first.kind_of?(OrderedRepresentation).should be_true
      @manifestation.ordered_reps.first.files.length.should == 2
      @manifestation.ordered_reps.first.files.first.kind_of?(BasicFile).should be_true
      @manifestation.ordered_reps.first.files.first.original_filename.should == @tiff.original_filename
      @manifestation.ordered_reps.first.files.last.kind_of?(BasicFile).should be_true
      @manifestation.ordered_reps.first.files.last.original_filename.should == @other_file.original_filename
    end

    it 'should validate the structmap' do
      add_order_rep([@tiff, @other_file], {}, @manifestation).should be_true

      structmap = @manifestation.representations.last.techMetadata.ng_xml.to_s
      structmap.index(@tiff.original_filename).should be < structmap.index(@other_file.original_filename)
    end
  end

  describe '#set_authors' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @person1 = Person.create(:firstname => 'firstname1', :lastname => 'lastname1', :date_of_birth => Time.now.nsec.to_s)
      @person2 = Person.create(:firstname => 'firstname2', :lastname => 'lastname2', :date_of_birth => Time.now.nsec.to_s)
      @person3 = Person.create(:firstname => 'firstname3', :lastname => 'lastname3', :date_of_birth => Time.now.nsec.to_s)
    end

    it 'should be possible to add one person' do
      set_authors([@person1.id], @manifestation).should be_true
      #reload
      m = Work.find(@manifestation.pid)
      p1 = Person.find(@person1.pid)
      p2 = Person.find(@person2.pid)
      p3 = Person.find(@person3.pid)

      m.has_author?.should be_true
      m.authors.length.should == 1
      m.authors.should == [p1]

      p1.authored_manifestations.length.should == 1
      p1.authored_manifestations.should == [m]

      p2.authored_manifestations.length.should == 0
      p3.authored_manifestations.length.should == 0
    end

    it 'should be possible to add more than one person' do
      set_authors([@person1.id, @person2.id, @person3.id], @manifestation).should be_true
      #reload
      m = Work.find(@manifestation.pid)
      p1 = Person.find(@person1.pid)
      p2 = Person.find(@person2.pid)
      p3 = Person.find(@person3.pid)

      m.has_author?.should be_true
      m.authors.length.should == 3
      m.authors.include?(@person1).should be_true
      m.authors.include?(@person2).should be_true
      m.authors.include?(@person3).should be_true

      p1.authored_manifestations.length.should == 1
      p1.authored_manifestations.should == [m]

      p2.authored_manifestations.length.should == 1
      p2.authored_manifestations.should == [m]

      p3.authored_manifestations.length.should == 1
      p3.authored_manifestations.should == [m]
    end

    it 'should allow the empty set' do
      set_authors([], @manifestation).should be_false
      m = Work.find(@manifestation.pid)
      p1 = Person.find(@person1.pid)
      p2 = Person.find(@person2.pid)
      p3 = Person.find(@person3.pid)

      m.has_author?.should be_false
      m.authors.length.should == 0
      p1.authored_manifestations.length.should == 0
      p2.authored_manifestations.length.should == 0
      p3.authored_manifestations.length.should == 0
    end
  end

  describe '#set_concerned_people' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @person1 = Person.create(:firstname => 'firstname1', :lastname => 'lastname1', :date_of_birth => Time.now.nsec.to_s)
      @person2 = Person.create(:firstname => 'firstname2', :lastname => 'lastname2', :date_of_birth => Time.now.nsec.to_s)
      @person3 = Person.create(:firstname => 'firstname3', :lastname => 'lastname3', :date_of_birth => Time.now.nsec.to_s)
    end

    it 'should be possible to add one person' do
      set_concerned_people([@person1.id], @manifestation).should be_true
      #reload
      m = Work.find(@manifestation.pid)
      p1 = Person.find(@person1.pid)
      p2 = Person.find(@person2.pid)
      p3 = Person.find(@person3.pid)

      m.has_concerned_person?.should be_true
      m.people_concerned.length.should == 1
      m.people_concerned.should == [p1]

      p1.concerning_manifestations.length.should == 1
      p1.concerning_manifestations.should == [m]

      p2.concerning_manifestations.length.should == 0
      p3.concerning_manifestations.length.should == 0
    end

    it 'should be possible to add more than one person' do
      set_concerned_people([@person1.id, @person2.id, @person3.id], @manifestation).should be_true
      #reload
      m = Work.find(@manifestation.pid)
      p1 = Person.find(@person1.pid)
      p2 = Person.find(@person2.pid)
      p3 = Person.find(@person3.pid)

      m.has_concerned_person?.should be_true
      m.people_concerned.length.should == 3
      m.people_concerned.include?(@person1).should be_true
      m.people_concerned.include?(@person2).should be_true
      m.people_concerned.include?(@person3).should be_true

      p1.concerning_manifestations.length.should == 1
      p1.concerning_manifestations.should == [m]

      p2.concerning_manifestations.length.should == 1
      p2.concerning_manifestations.should == [m]

      p3.concerning_manifestations.length.should == 1
      p3.concerning_manifestations.should == [m]
    end

    it 'should allow the empty set' do
      set_concerned_people([], @manifestation).should be_false
      m = Work.find(@manifestation.pid)
      p1 = Person.find(@person1.pid)
      p2 = Person.find(@person2.pid)
      p3 = Person.find(@person3.pid)

      m.has_concerned_person?.should be_false
      m.people_concerned.length.should == 0
      p1.concerning_manifestations.length.should == 0
      p2.concerning_manifestations.length.should == 0
      p3.concerning_manifestations.length.should == 0
    end
  end

  describe '#create_structmap' do
    before(:each) do
      @manifestation = Work.create(:title => 'Work')
      @file1 = ActionDispatch::Http::UploadedFile.new(filename: 'arre1fm001.xml', type: 'image/tif', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      @file2 = ActionDispatch::Http::UploadedFile.new(filename: 'rails.png', type: 'octet-stream', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))
    end

    it 'should create structmap and be able to restructure it afterwards' do
      add_order_rep([@file1, @file2], {}, @manifestation)

      xml_before_ordering = @manifestation.representations.last.techMetadata.ng_xml.to_s
      xml_before_ordering.index(@file1.original_filename).should be < xml_before_ordering.index(@file2.original_filename)

      order = @file2.original_filename.to_s + ',' + @file1.original_filename.to_s
      create_structmap_for_representation(order, @manifestation.representations.last)

      xml_after_ordering = @manifestation.representations.last.techMetadata.ng_xml.to_s
      xml_after_ordering.index(@file1.original_filename).should be > xml_after_ordering.index(@file2.original_filename)
    end

    it 'should be the same after reload' do
      add_order_rep([@file1, @file2], {}, @manifestation)
      structmap = @manifestation.representations.last.techMetadata.ng_xml.to_s

      rep = OrderedRepresentation.find(@manifestation.representations.last.pid)
      rep.techMetadata.should_not be_nil
      # TODO this is very odd. The UTF-8 encoding is on when it is created, but not when it has been reloaded...
      rep.techMetadata.ng_xml.encoding = 'UTF-8'
      structmap.should == rep.techMetadata.ng_xml.to_s
    end
  end
end