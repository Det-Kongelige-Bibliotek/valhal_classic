# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::WorkDescMetadata do

  before :all do
    class WorkDescTester < ActiveFedora::Base
      has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata
    end
  end


  it 'should contain fields for the internal Work metadata' do
    wdt = WorkDescTester.create
    wdt.descMetadata.title.should == ['']
    wdt.descMetadata.subTitle.should be_empty
    wdt.descMetadata.workType.should == ['']
    wdt.descMetadata.genre.should be_empty
    wdt.descMetadata.languageOfCataloging.should be_empty
    wdt.descMetadata.topic.should be_empty
    wdt.descMetadata.cartographicsScale.should be_empty
    wdt.descMetadata.cartographicsCoordinates.should be_empty
    wdt.descMetadata.typeOfResource.should be_empty
    wdt.descMetadata.typeOfResourceLabel.should be_empty
    wdt.descMetadata.dateCreated.should be_empty
    wdt.descMetadata.dateOther.should be_empty
    wdt.descMetadata.tableOfContents.should be_empty
    wdt.descMetadata.recordOriginInfo.should be_empty
  end

  describe '#edit' do
    it 'should be possible to edit the title field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.title.should == ['']
      wdt.descMetadata.title = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.title.should == ['TEST']
    end

    it 'should be possible to edit the subTitle field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.subTitle.should be_empty
      wdt.descMetadata.subTitle = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.subTitle.should == ['TEST']
    end

    it 'should be possible to edit the workType field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.workType.should == ['']
      wdt.descMetadata.workType = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.workType.should == ['TEST']
    end

    it 'should be possible to edit the languageOfCataloging field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.languageOfCataloging.should be_empty
      wdt.descMetadata.languageOfCataloging = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.languageOfCataloging.should == ['TEST']
    end

    it 'should be possible to edit the topic field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.topic.should be_empty
      wdt.descMetadata.topic = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.topic.should == ['TEST']
    end

    it 'should be possible to edit the cartographicsScale field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.cartographicsScale.should be_empty
      wdt.descMetadata.cartographicsScale = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.cartographicsScale.should == ['TEST']
    end

    it 'should be possible to edit the cartographicsCoordinates field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.cartographicsCoordinates.should be_empty
      wdt.descMetadata.cartographicsCoordinates = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.cartographicsCoordinates.should == ['TEST']
    end

    it 'should be possible to edit the typeOfResource field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.typeOfResource.should be_empty
      wdt.descMetadata.typeOfResource = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.typeOfResource.should == ['TEST']
    end

    it 'should be possible to edit the typeOfResourceLabel field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.typeOfResourceLabel.should be_empty
      wdt.descMetadata.typeOfResourceLabel = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.typeOfResourceLabel.should == ['TEST']
    end

    it 'should be possible to edit the dateCreated field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.dateCreated.should be_empty
      wdt.descMetadata.dateCreated = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.dateCreated.should == ['TEST']
    end

    it 'should be possible to edit the dateOther field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.dateOther.should be_empty
      wdt.descMetadata.dateOther = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.dateOther.should == ['TEST']
    end

    it 'should be possible to edit the tableOfContents field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.tableOfContents.should be_empty
      wdt.descMetadata.tableOfContents = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.tableOfContents.should == ['TEST']
    end

    it 'should be possible to edit the recordOriginInfo field' do
      wdt = WorkDescTester.create
      wdt.descMetadata.recordOriginInfo.should be_empty
      wdt.descMetadata.recordOriginInfo = 'TEST'
      wdt.save!
      wdt.reload
      wdt.descMetadata.recordOriginInfo.should == ['TEST']
    end
  end

end