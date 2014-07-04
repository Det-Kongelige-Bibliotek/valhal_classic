# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Relations between AuthorityMetadataUnits and Works" do
  before :each do
    @w = Work.create!(:title => 'Test title', :work_type => 'Test type')
    @a = AuthorityMetadataUnit.create!(:type => AMU_TYPES.last)
  end

  describe "#topic" do
    it 'should be possible from work point of view' do
      @w.hasTopic.should be_empty
      @w.hasTopic << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasTopic.should == [@a]
      @a.isTopicOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isTopicOf.should be_empty
      @a.isTopicOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isTopicOf.should == [@w]
      @w.hasTopic.should == [@a]
    end
  end

  describe "#origin" do
    it 'should be possible from work point of view' do
      @w.hasOrigin.should be_empty
      @w.hasOrigin << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasOrigin.should == [@a]
      @a.isOriginOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isOriginOf.should be_empty
      @a.isOriginOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isOriginOf.should == [@w]
      @w.hasOrigin.should == [@a]
    end
  end

  describe "#addresee" do
    it 'should be possible from work point of view' do
      @w.hasAddressee.should be_empty
      @w.hasAddressee << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasAddressee.should == [@a]
      @a.isAddresseeOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isAddresseeOf.should be_empty
      @a.isAddresseeOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isAddresseeOf.should == [@w]
      @w.hasAddressee.should == [@a]
    end
  end

  describe "#author" do
    it 'should be possible from work point of view' do
      @w.hasAuthor.should be_empty
      @w.hasAuthor << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasAuthor.should == [@a]
      @a.isAuthorOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isAuthorOf.should be_empty
      @a.isAuthorOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isAuthorOf.should == [@w]
      @w.hasAuthor.should == [@a]
    end
  end

  describe "#contributor" do
    it 'should be possible from work point of view' do
      @w.hasContributor.should be_empty
      @w.hasContributor << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasContributor.should == [@a]
      @a.isContributorOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isContributorOf.should be_empty
      @a.isContributorOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isContributorOf.should == [@w]
      @w.hasContributor.should == [@a]
    end
  end

  describe "#creator" do
    it 'should be possible from work point of view' do
      @w.hasCreator.should be_empty
      @w.hasCreator << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasCreator.should == [@a]
      @a.isCreatorOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isCreatorOf.should be_empty
      @a.isCreatorOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isCreatorOf.should == [@w]
      @w.hasCreator.should == [@a]
    end
  end

  describe "#owner" do
    it 'should be possible from work point of view' do
      @w.hasOwner.should be_empty
      @w.hasOwner << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasOwner.should == [@a]
      @a.isOwnerOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isOwnerOf.should be_empty
      @a.isOwnerOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isOwnerOf.should == [@w]
      @w.hasOwner.should == [@a]
    end
  end

  describe "#patron" do
    it 'should be possible from work point of view' do
      @w.hasPatron.should be_empty
      @w.hasPatron << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasPatron.should == [@a]
      @a.isPatronOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isPatronOf.should be_empty
      @a.isPatronOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isPatronOf.should == [@w]
      @w.hasPatron.should == [@a]
    end
  end

  describe "#performer" do
    it 'should be possible from work point of view' do
      @w.hasPerformer.should be_empty
      @w.hasPerformer << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasPerformer.should == [@a]
      @a.isPerformerOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isPerformerOf.should be_empty
      @a.isPerformerOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isPerformerOf.should == [@w]
      @w.hasPerformer.should == [@a]
    end
  end

  describe "#photographer" do
    it 'should be possible from work point of view' do
      @w.hasPhotographer.should be_empty
      @w.hasPhotographer << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasPhotographer.should == [@a]
      @a.isPhotographerOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isPhotographerOf.should be_empty
      @a.isPhotographerOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isPhotographerOf.should == [@w]
      @w.hasPhotographer.should == [@a]
    end
  end

  describe "#translator" do
    it 'should be possible from work point of view' do
      @w.hasTranslator.should be_empty
      @w.hasTranslator << @a
      @w.save!
      @w.reload
      @a.reload
      @w.hasTranslator.should == [@a]
      @a.isTranslatorOf.should == [@w]
    end

    it 'should be possible from AuthorityMetadataUnit point of view' do
      @a.isTranslatorOf.should be_empty
      @a.isTranslatorOf << @w
      @a.save!
      @w.reload
      @a.reload
      @a.isTranslatorOf.should == [@w]
      @w.hasTranslator.should == [@a]
    end
  end

end
