# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Datastreams::InstanceDescMetadata do

  before :all do
    class InstanceDescTester < ActiveFedora::Base
      has_metadata :name => 'descMetadata', :type => Datastreams::InstanceDescMetadata
    end
  end


  it 'should contain fields for the internal Work metadata' do
    idt = InstanceDescTester.create
    idt.descMetadata.shelfLocator.should be_empty
    idt.descMetadata.physicalDescriptionForm.should be_empty
    idt.descMetadata.physicalDescriptionNote.should be_empty
    idt.descMetadata.languageOfCataloging.should be_empty
    idt.descMetadata.dateCreated.should be_empty
    idt.descMetadata.dateIssued.should be_empty
    idt.descMetadata.dateOther.should be_empty
    idt.descMetadata.recordOriginInfo.should be_empty
    idt.descMetadata.tableOfContents.should be_empty
  end

  describe '#edit' do
    it 'should be possible to edit the shelfLocator field' do
      idt = InstanceDescTester.create
      idt.descMetadata.shelfLocator.should be_empty
      idt.descMetadata.shelfLocator = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.shelfLocator.should == ['TEST']
    end

    it 'should be possible to edit the physicalDescriptionForm field' do
      idt = InstanceDescTester.create
      idt.descMetadata.physicalDescriptionForm.should be_empty
      idt.descMetadata.physicalDescriptionForm = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.physicalDescriptionForm.should == ['TEST']
    end

    it 'should be possible to edit the physicalDescriptionNote field' do
      idt = InstanceDescTester.create
      idt.descMetadata.physicalDescriptionNote.should be_empty
      idt.descMetadata.physicalDescriptionNote = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.physicalDescriptionNote.should == ['TEST']
    end

    it 'should be possible to edit the languageOfCataloging field' do
      idt = InstanceDescTester.create
      idt.descMetadata.languageOfCataloging.should be_empty
      idt.descMetadata.languageOfCataloging = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.languageOfCataloging.should == ['TEST']
    end

    it 'should be possible to edit the dateCreated field' do
      idt = InstanceDescTester.create
      idt.descMetadata.dateCreated.should be_empty
      idt.descMetadata.dateCreated = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.dateCreated.should == ['TEST']
    end

    it 'should be possible to edit the dateIssued field' do
      idt = InstanceDescTester.create
      idt.descMetadata.dateIssued.should be_empty
      idt.descMetadata.dateIssued = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.dateIssued.should == ['TEST']
    end

    it 'should be possible to edit the dateOther field' do
      idt = InstanceDescTester.create
      idt.descMetadata.dateOther.should be_empty
      idt.descMetadata.dateOther = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.dateOther.should == ['TEST']
    end

    it 'should be possible to edit the recordOriginInfo field' do
      idt = InstanceDescTester.create
      idt.descMetadata.recordOriginInfo.should be_empty
      idt.descMetadata.recordOriginInfo = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.recordOriginInfo.should == ['TEST']
    end

    it 'should be possible to edit the tableOfContents field' do
      idt = InstanceDescTester.create
      idt.descMetadata.tableOfContents.should be_empty
      idt.descMetadata.tableOfContents = 'TEST'
      idt.save!
      idt.reload
      idt.descMetadata.tableOfContents.should == ['TEST']
    end
  end

end