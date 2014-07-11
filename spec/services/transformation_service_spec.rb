require 'spec_helper'

describe "transformation" do
  describe "#transform_to_mods" do
    before :all do
      class WorkTestClass < ActiveFedora::Base
        include Concerns::WorkInstanceRelations
        has_metadata :name => 'descMetadata', :type => Datastreams::WorkDescMetadata
        has_many :instances, :class_name => 'ActiveFedora::Base', :property=>:is_representation_of, :inverse_of => :has_representation

        # Extracts the relations, which are valid for work.
        def get_relations
          res = Hash.new
          relations = METADATA_RELATIONS_CONFIG['work']
          get_all_relations.each do |k,v|
            if relations.include?(k) && v.empty? == false
              res[k] = v
            end
          end
          res
        end
      end

      class InstanceTestClass < ActiveFedora::Base
        include Concerns::WorkInstanceRelations
        has_metadata :name => 'descMetadata', :type => Datastreams::InstanceDescMetadata
        belongs_to :work, :class_name => 'ActiveFedora::Base', :property => :has_representation, :inverse_of => :is_representation_of

        # Extracts the relations, which are valid for work.
        def get_relations
          res = Hash.new
          relations = METADATA_RELATIONS_CONFIG['instance']
          get_all_relations.each do |k,v|
            if relations.include?(k) && v.empty? == false
              res[k] = v
            end
          end
          res
        end
      end

    end

    describe "Work and Instance to MODS" do
      before :all do
        @place = AuthorityMetadataUnit.create(:type=>'place', :value => 'TEST place', :reference => 'http://authority.org/place')
        @concept = AuthorityMetadataUnit.create(:type=>'concept', :value => 'TEST concept', :reference => 'http://authority.org/concept')
        @event = AuthorityMetadataUnit.create(:type=>'event', :value => 'TEST event', :reference => 'http://authority.org/event')
        @physicalThing = AuthorityMetadataUnit.create(:type=>'physicalThing', :value => 'TEST physicalThing', :reference => 'http://authority.org/physicalThing')
        @agent = AuthorityMetadataUnit.create(:type=>'agent/person', :value => 'TEST person', :reference => 'http://authority.org/person')

        @work = WorkTestClass.create
        @work.descMetadata.title = 'Title'
        @work.descMetadata.subTitle = 'SubTitle'
        @work.descMetadata.workType = 'WorkType'
        @work.descMetadata.genre = 'Genre'
        @work.descMetadata.languageOfCataloging = 'LanguageOfCataloging'
        @work.descMetadata.topic = 'Topic'
        @work.descMetadata.cartographicsScale = 'CartographicsScale'
        @work.descMetadata.cartographicsCoordinates = 'CartographicsCoordinates'
        @work.descMetadata.typeOfResource = 'text' #'TypeOfResource'
        @work.descMetadata.typeOfResourceLabel = 'TypeOfResourceLabel'
        @work.descMetadata.dateCreated = 'DateCreated'
        @work.descMetadata.dateOther = 'DateOther'
        @work.descMetadata.tableOfContents = 'TableOfContents'
        @work.descMetadata.recordOriginInfo = 'RecordOriginInfo'
        @work.descMetadata.insert_alternative_title ({'title'=> 'alternativeTitle', 'subTitle' => 'alternative subTitle', 'type' => 'alternative'})
        @work.descMetadata.insert_alternative_title ({'title'=> 'translatedTitle', 'subTitle' => 'translated subTitle', 'type' => 'translated', 'lang' => 'da'})
        @work.descMetadata.insert_alternative_title ({'title'=> 'uniformTitle', 'subTitle' => 'uniform subTitle', 'type' => 'uniform'})
        @work.descMetadata.insert_alternative_title ({'title'=> 'Abb.T.', 'subTitle' => 'Abb. sT.', 'type' => 'abbreviated'})
        @work.descMetadata.insert_alternative_title ({'title'=> 'otherTitle', 'subTitle' => 'other subTitle', 'type' => 'other', 'displayLabel' => 'displayLabel to other type'})
        @work.descMetadata.insert_identifier ({'value'=> 'identifier', 'displayLabel' => 'I am a displayLabel'})
        @work.descMetadata.insert_note ({'value'=> 'identifier', 'displayLabel' => 'I am a displayLabel'})
        @work.descMetadata.insert_language ({'value'=> 'language', 'authority' => 'http://authority.org'})
        @work.hasOrigin << @place
        @work.hasTopic << @place
        @work.hasTopic << @concept
        @work.hasTopic << @event
        @work.hasTopic << @physicalThing
        @work.hasTopic << @agent
        @work.hasAddressee << @agent
        @work.hasAuthor << @agent
        @work.hasContributor << @agent
        @work.hasCreator << @agent
        @work.hasOwner << @agent
        @work.hasPatron << @agent
        @work.hasPerformer << @agent
        @work.hasPhotographer << @agent
        @work.hasPrinter << @agent
        @work.hasPublisher << @agent
        @work.hasScribe << @agent
        @work.hasTranslator << @agent
        @work.hasDigitizer << @agent
        @work.save!

        @instance = InstanceTestClass.create

        @instance.descMetadata.shelfLocator = 'ShelfLocator'
        @instance.descMetadata.physicalDescriptionForm = 'physicalDescriptionForm'
        @instance.descMetadata.physicalDescriptionNote = 'physicalDescriptionNote'
        @instance.descMetadata.languageOfCataloging = 'LanguageOfCataloging'
        @instance.descMetadata.dateCreated = 'DateCreated'
        @instance.descMetadata.dateIssued = 'DateIssued'
        @instance.descMetadata.dateOther = 'DateOther'
        @instance.descMetadata.recordOriginInfo = 'RecordOriginInfo'
        @instance.descMetadata.tableOfContents = 'TableOfContents'
        @instance.descMetadata.insert_identifier ({'value'=> 'identifier', 'displayLabel' => 'I am a displayLabel'})
        @instance.descMetadata.insert_note ({'value'=> 'identifier', 'displayLabel' => 'I am a displayLabel'})
        @instance.hasOrigin << @place
        @instance.hasTopic << @place
        @instance.hasTopic << @concept
        @instance.hasTopic << @event
        @instance.hasTopic << @physicalThing
        @instance.hasTopic << @agent
        @instance.hasAddressee << @agent
        @instance.hasAuthor << @agent
        @instance.hasContributor << @agent
        @instance.hasCreator << @agent
        @instance.hasOwner << @agent
        @instance.hasPatron << @agent
        @instance.hasPerformer << @agent
        @instance.hasPhotographer << @agent
        @instance.hasPrinter << @agent
        @instance.hasPublisher << @agent
        @instance.hasScribe << @agent
        @instance.hasTranslator << @agent
        @instance.hasDigitizer << @agent

        @instance.work = @work
        @instance.save!


      end

      it 'should be possible to extract the metadata' do
        mods = TransformationService.transform_to_mods(@work)
        xsd = Nokogiri::XML::Schema(File.read("#{Rails.root}/spec/fixtures/mods-3-5.xsd"))
        output = xsd.validate(mods)

        output.each do |error|
          puts error
        end

        output.should be_empty
      end

      it 'should be possible to extract the metadata' do
        mods = TransformationService.transform_to_mods(@instance)
        xsd = Nokogiri::XML::Schema(File.read("#{Rails.root}/spec/fixtures/mods-3-5.xsd"))
        output = xsd.validate(mods)

        output.each do |error|
          puts error
        end

        output.should be_empty
      end
    end
  end

  describe "#transform_from_mods" do
    it 'should create a work and an instance from the Valhal-mods' do
      mods = Nokogiri::XML::Document.parse(File.read("#{Rails.root}/spec/fixtures/valhal_mods.xml"))
      w, i = TransformationService.create_from_mods(mods, [])

      w.should be_a(Work)
      i.should be_a(SingleFileInstance)

      i.ie.should == w
      w.instances.should == [i]
    end
  end
end
