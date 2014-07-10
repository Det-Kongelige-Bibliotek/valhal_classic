# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Relations between AuthorityMetadataUnits and Works" do
  before :each do
    @i = SingleFileInstance.create!
    @a = AuthorityMetadataUnit.create!(:type => AMU_TYPES.last)
  end

  describe "#topic" do
    it 'should be possible from work point of view' do
      @i.hasTopic.should be_empty
      @i.hasTopic << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasTopic.should == [@a]
      @a.isTopicOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isTopicOf.should be_empty
      @a.isTopicOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isTopicOf.should == [@i]
      @i.hasTopic.should == [@a]
    end
  end

  describe "#origin" do
    it 'should be possible from work point of view' do
      @i.hasOrigin.should be_empty
      @i.hasOrigin << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasOrigin.should == [@a]
      @a.isOriginOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isOriginOf.should be_empty
      @a.isOriginOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isOriginOf.should == [@i]
      @i.hasOrigin.should == [@a]
    end
  end

  describe "#contributor" do
    it 'should be possible from work point of view' do
      @i.hasContributor.should be_empty
      @i.hasContributor << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasContributor.should == [@a]
      @a.isContributorOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isContributorOf.should be_empty
      @a.isContributorOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isContributorOf.should == [@i]
      @i.hasContributor.should == [@a]
    end
  end

  describe "#owner" do
    it 'should be possible from work point of view' do
      @i.hasOwner.should be_empty
      @i.hasOwner << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasOwner.should == [@a]
      @a.isOwnerOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isOwnerOf.should be_empty
      @a.isOwnerOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isOwnerOf.should == [@i]
      @i.hasOwner.should == [@a]
    end
  end

  describe "#patron" do
    it 'should be possible from work point of view' do
      @i.hasPatron.should be_empty
      @i.hasPatron << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasPatron.should == [@a]
      @a.isPatronOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isPatronOf.should be_empty
      @a.isPatronOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isPatronOf.should == [@i]
      @i.hasPatron.should == [@a]
    end
  end


  describe "#printer" do
    it 'should be possible from work point of view' do
      @i.hasPrinter.should be_empty
      @i.hasPrinter << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasPrinter.should == [@a]
      @a.isPrinterOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isPrinterOf.should be_empty
      @a.isPrinterOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isPrinterOf.should == [@i]
      @i.hasPrinter.should == [@a]
    end
  end

  describe "#publisher" do
    it 'should be possible from work point of view' do
      @i.hasPublisher.should be_empty
      @i.hasPublisher << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasPublisher.should == [@a]
      @a.isPublisherOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isPublisherOf.should be_empty
      @a.isPublisherOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isPublisherOf.should == [@i]
      @i.hasPublisher.should == [@a]
    end
  end

  describe "#scribe" do
    it 'should be possible from work point of view' do
      @i.hasScribe.should be_empty
      @i.hasScribe << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasScribe.should == [@a]
      @a.isScribeOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isScribeOf.should be_empty
      @a.isScribeOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isScribeOf.should == [@i]
      @i.hasScribe.should == [@a]
    end
  end

  describe "#digitizer" do
    it 'should be possible from work point of view' do
      @i.hasDigitizer.should be_empty
      @i.hasDigitizer << @a
      @i.save!
      @i.reload
      @a.reload
      @i.hasDigitizer.should == [@a]
      @a.isDigitizerOf.should == [@i]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isDigitizerOf.should be_empty
      @a.isDigitizerOf << @i
      @a.save!
      @i.reload
      @a.reload
      @a.isDigitizerOf.should == [@i]
      @i.hasDigitizer.should == [@a]
    end
  end

end
