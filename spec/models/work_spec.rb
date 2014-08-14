# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Work do
  subject { Work.new(title: 'test' + Time.now.nsec.to_s) }

  it_behaves_like 'a preservable element'

  describe '#title' do
    it 'should be created with a title' do
      t = 'The title'
      w = Work.new(:title => t)
      w.save.should be_true
      w.title.should == t
    end

    it 'should not be possible to create a work without a work type' do
      w = Work.new
      w.save.should be_false
    end

    it 'should be possible to change the title' do
      t = 'The new title'
      w = Work.new(:title => 'some title')
      w.save!
      w.title.should_not be_nil
      w.title = t;
      w.save!
      w.title.should == t;
    end
  end

  describe '#identifier' do
    it 'should be possible to search by an identifier' do
      w = Work.new(title: 'title', identifier: [{'displayLabel' => 'sysnum', 'value' => 'alephsys'}])
      w.save
      f = Work.find(sysnum_si: 'alephsys').first
      f.title.should eql 'title'
    end

  end

  describe '#worktype' do
    it 'should be created with a worktype' do
      type = 'The worktype'
      w = Work.new(:title => 'title', :workType => type)
      w.save.should be_true
      w.workType.should == type
    end

    it 'should be possible to create a work without a workType' do
      w = Work.new(:title => 'title')
      w.save.should be_true
    end

    it 'should be created with a worktype' do
      type = 'The new worktype'
      w = Work.new(:title => 'title', :workType => 'Some worktype')
      w.save!
      w.workType.should_not be_nil
      w.workType = type
      w.save!
      w.workType.should == type
    end
  end

  describe '#attributes' do
    before(:each) do
      @attributes_hash = {
          uuid: 'urn:uuid:53246d30-34b4-11e2-81c1-0800200c9a66',
          title: 'Some test title' + Time.now.nsec.to_s,
          subTitle: 'Bd. 1',
          workType: 'The test type of work',
          cartographicsScale: 'cartographicsScale',
          cartographicsCoordinates: 'cartographicsCoordinates',
          dateCreated: '2002-10-02T10:00:00-05:00',
          tableOfContents: 'tableOfContents',
          typeOfResource: 'text',
          typeOfResourceLabel: 'typeOfResourceLabel',
          recordOriginInfo: 'recordOriginInfo',
          dateOther: '2002-10-02T10:00:00-05:00',
          genre: 'any genre',
          languageOfCataloging: 'da',
          topic: 'N8217.H68'
      }
    end

    it 'should be possible to create with the attributes' do
      w = Work.new(@attributes_hash)
      w.save.should be_true

      w.uuid.should == @attributes_hash[:uuid]
      w.subTitle.should == @attributes_hash[:subTitle]
      w.title.should == @attributes_hash[:title]
      w.workType.should == @attributes_hash[:workType]
      w.cartographicsScale.should == @attributes_hash[:cartographicsScale]
      w.cartographicsCoordinates.should == @attributes_hash[:cartographicsCoordinates]
      w.tableOfContents.should == @attributes_hash[:tableOfContents]
      w.typeOfResource.should == @attributes_hash[:typeOfResource]
      w.typeOfResourceLabel.should == @attributes_hash[:typeOfResourceLabel]
      w.recordOriginInfo.should == @attributes_hash[:recordOriginInfo]
      w.recordOriginInfo.should == @attributes_hash[:recordOriginInfo]
      w.dateOther.should == @attributes_hash[:dateOther]
      w.genre.should == @attributes_hash[:genre]
      w.languageOfCataloging.should == @attributes_hash[:languageOfCataloging]
      w.topic.should == @attributes_hash[:topic]
    end

    it 'should be possible to update with the attributes' do
      w = Work.new(:title => 'Random title' + Time.now.nsec.to_s)
      w.save!

      w.uuid.should_not be_blank
      w.title.should_not be_blank
      w.subTitle.should be_blank
      w.workType.should be_blank
      w.typeOfResource.should be_blank
      w.typeOfResourceLabel.should be_blank
      w.cartographicsScale.should be_blank
      w.cartographicsCoordinates.should be_blank
      w.tableOfContents.should be_blank
      w.recordOriginInfo.should be_blank
      w.dateOther.should be_blank
      w.genre.should be_blank
      w.languageOfCataloging.should be_blank
      w.topic.should be_blank

      w.update_attributes(@attributes_hash)

      w.uuid.should == @attributes_hash[:uuid]
      w.subTitle.should == @attributes_hash[:subTitle]
      w.title.should == @attributes_hash[:title]
      w.workType.should == @attributes_hash[:workType]
      w.cartographicsScale.should == @attributes_hash[:cartographicsScale]
      w.cartographicsCoordinates.should == @attributes_hash[:cartographicsCoordinates]
      w.tableOfContents.should == @attributes_hash[:tableOfContents]
      w.typeOfResource.should == @attributes_hash[:typeOfResource]
      w.typeOfResourceLabel.should == @attributes_hash[:typeOfResourceLabel]
      w.recordOriginInfo.should == @attributes_hash[:recordOriginInfo]
      w.recordOriginInfo.should == @attributes_hash[:recordOriginInfo]
      w.dateOther.should == @attributes_hash[:dateOther]
      w.genre.should == @attributes_hash[:genre]
      w.languageOfCataloging.should == @attributes_hash[:languageOfCataloging]
      w.topic.should == @attributes_hash[:topic]
    end
  end

  describe '#get_title_for_display' do
    it 'should contain both the title and subtitle when both is defined' do
      t = 'The title' + Time.now.nsec.to_s
      st = 'The subtitle'
      w = Work.new(:title => t, :subTitle => st)
      w.save!

      d = w.get_title_for_display
      d.include?(t).should be_true
      d.include?(st).should be_true
      d.include?(',').should be_true
    end

    it 'should only contain the title when no subtitle is defined' do
      t = 'The title' + Time.now.nsec.to_s
      st = 'The subtitle'
      w = Work.new(:title => t)
      w.save!

      d = w.get_title_for_display
      d.include?(t).should be_true
      d.include?(st).should be_false
      d.include?(',').should be_false
    end
  end

  describe ' validation' do
    it 'should not be possible to create two identical works' do
      pending "No such validation yet!"
      title = 'identical work'
      workType = 'identical work'
      Work.create(:title => title, :workType => workType).should be_true

      identicalWork = Work.new(:title => title, :workType => workType)
      identicalWork.save.should be_false
    end

    it 'should not be possible to create two works with the same identifier' do
      w = Work.new(title: 'title')
      w.identifier= [{'displayLabel' => 'sysnum', 'value' => '1234'}]
      w.save

      w2 = Work.new(title: 'title, 2nd ed.')
      w2.identifier= [{'displayLabel' => 'sysnum', 'value' => '1234'}]
      w2.save.should be_false
    end
  end

  describe 'identifier=' do
    it 'should create an accessor method for an identifier given' do
      w = Work.new(title: 'title')
      w.identifier= [{'displayLabel' => 'sysnum', 'value' => '1234'}]
      w.sysnum.should eql '1234'
    end
  end

  after(:all) do
    Work.all.each {|w| w.delete }
  end
end
