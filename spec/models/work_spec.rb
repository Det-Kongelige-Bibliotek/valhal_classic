# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Work do
  subject { Book.new(title: "test") }

  it_behaves_like "a manifestation with authors"

  it_behaves_like "a manifestation with concerns"

  describe '#title' do
    it 'should be created with a title' do
      t = "The title"
      w = Work.new(:title => t)
      w.save.should be_true
      w.title.should == t
    end

    it 'should not be possible to create a work without a title' do
      w = Work.new
      w.save.should be_false
    end

    it 'should be possible to change the title' do
      t = "The new title"
      w = Work.new(:title => "some title")
      w.save!
      w.title.should_not be_nil
      w.title = t;
      w.save!
      w.title.should == t;
    end
  end

  describe '#worktype' do
    it 'should be created with a worktype' do
      type = "The worktype"
      w = Work.new(:title => "title", :work_type => type)
      w.save.should be_true
      w.work_type.should == type
    end

    it 'should be possible to create a work without a title' do
      w = Work.new(:title => "title")
      w.save.should be_true
    end

    it 'should be created with a worktype' do
      type = "The new worktype"
      w = Work.new(:title => "title", :work_type => "Some worktype")
      w.save!
      w.work_type.should_not be_nil
      w.work_type = type
      w.save!
      w.work_type.should == type
    end
  end

  describe '#attributes' do
    before :all do
      @attributes_hash = {
          title: "Some test title",
          work_type: "The test type of work",
          uuid: "urn:uuid:53246d30-34b4-11e2-81c1-0800200c9a66",
          typeOfResource: "text",
          shelfLocator: "Pligtaflevering",
          subTitle: "Bd. 1",
          publisher: "Det Danske Sprog og Litteraturselskab",
          originPlace: "Copenhagen",
          dateIssued: "2002-10-02T10:00:00-05:00",
          languageISO: "dan",
          languageText: "DANSK",
          subjectTopic: "N8217.H68",
          physicalExtent: "510"
      }
    end

    it "should be possible to create with the attributes" do
      w = Work.new(@attributes_hash)
      w.save.should be_true

      w.title.should == @attributes_hash[:title]
      w.work_type.should == @attributes_hash[:work_type]
      w.uuid.should == @attributes_hash[:uuid]
      w.typeOfResource.should == @attributes_hash[:typeOfResource]
      w.shelfLocator.should == @attributes_hash[:shelfLocator]
      w.subTitle.should == @attributes_hash[:subTitle]
      w.publisher.should == @attributes_hash[:publisher]
      w.originPlace.should == @attributes_hash[:originPlace]
      w.dateIssued.should == @attributes_hash[:dateIssued]
      w.languageISO.should == @attributes_hash[:languageISO]
      w.languageText.should == @attributes_hash[:languageText]
      w.subjectTopic.should == @attributes_hash[:subjectTopic]
      w.physicalExtent.should == @attributes_hash[:physicalExtent]
    end

    it "should be possible to update with the attributes" do
      w = Work.new(:title => "Random title")
      w.save!

      w.title.should_not be_blank
      w.work_type.should be_blank
      w.uuid.should_not be_blank
      w.typeOfResource.should be_blank
      w.shelfLocator.should be_blank
      w.subTitle.should be_blank
      w.publisher.should be_blank
      w.originPlace.should be_blank
      w.dateIssued.should be_blank
      w.languageISO.should be_blank
      w.languageText.should be_blank
      w.subjectTopic.should be_blank
      w.physicalExtent.should be_blank

      w.update_attributes(@attributes_hash)

      w.title.should == @attributes_hash[:title]
      w.work_type.should == @attributes_hash[:work_type]
      w.uuid.should == @attributes_hash[:uuid]
      w.typeOfResource.should == @attributes_hash[:typeOfResource]
      w.shelfLocator.should == @attributes_hash[:shelfLocator]
      w.subTitle.should == @attributes_hash[:subTitle]
      w.publisher.should == @attributes_hash[:publisher]
      w.originPlace.should == @attributes_hash[:originPlace]
      w.dateIssued.should == @attributes_hash[:dateIssued]
      w.languageISO.should == @attributes_hash[:languageISO]
      w.languageText.should == @attributes_hash[:languageText]
      w.subjectTopic.should == @attributes_hash[:subjectTopic]
      w.physicalExtent.should == @attributes_hash[:physicalExtent]
    end
  end

  describe '#get_title_for_display' do
    it 'should contain both the title and subtitle when both is defined' do
      t = "The title";
      st = "The subtitle";
      w = Work.new(:title => t, :subTitle => st)
      w.save!

      d = w.get_title_for_display
      d.include?(t).should be_true
      d.include?(st).should be_true
      d.include?(',').should be_true
    end

    it 'should only contain the title when no subtitle is defined' do
      t = "The title";
      st = "The subtitle";
      w = Work.new(:title => t)
      w.save!

      d = w.get_title_for_display
      d.include?(t).should be_true
      d.include?(st).should be_false
      d.include?(',').should be_false
    end
  end
end
