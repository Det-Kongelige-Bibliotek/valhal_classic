require 'spec_helper'

describe "transformation" do
  describe "#transform_to_mods" do

    describe "Work and Instance to MODS" do
      before :all do
        @place = AuthorityMetadataUnit.create(:type=>'place', :value => 'TEST place', :reference => 'http://authority.org/place')
        @concept = AuthorityMetadataUnit.create(:type=>'concept', :value => 'TEST concept', :reference => 'http://authority.org/concept')
        @event = AuthorityMetadataUnit.create(:type=>'event', :value => 'TEST event', :reference => 'http://authority.org/event')
        @physicalThing = AuthorityMetadataUnit.create(:type=>'physicalThing', :value => 'TEST physicalThing', :reference => 'http://authority.org/physicalThing')
        @agent = AuthorityMetadataUnit.create(:type=>'agent/person', :value => 'TEST person', :reference => 'http://authority.org/person')

        @work = Work.create
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

        @instance = SingleFileInstance.create

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

        @instance.ie = @work
        @instance.save!
        @work.save!
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
    before :all do
      mods = Nokogiri::XML::Document.parse(File.read("#{Rails.root}/spec/fixtures/valhal_mods.xml"))
      @w, @i = TransformationService.create_from_mods(mods, [])
    end

    it 'should create a work with an instance from the Valhal-mods' do
      @w.should be_a(Work)
      @i.should be_a(SingleFileInstance)

      @i.ie.should == @w
      @w.instances.should == [@i]
    end

    it 'should place metadata on work and instance' do
      @w.title.should_not be_blank
      @w.subTitle.should_not be_blank
      @w.workType.should_not be_blank
      @w.cartographicsScale.should_not be_blank
      @w.cartographicsCoordinates.should_not be_blank
      @w.dateCreated.should_not be_blank
      @w.tableOfContents.should_not be_blank
      @w.typeOfResource.should_not be_blank
      @w.typeOfResourceLabel.should_not be_blank
      @w.recordOriginInfo.should_not be_blank
      @w.dateOther.should_not be_empty
      @w.genre.should_not be_empty
      @w.languageOfCataloging.should_not be_empty
      @w.topic.should_not be_empty
      @i.shelfLocator.should_not be_blank
      @i.dateCreated.should be_blank # is placed on work instead
      @i.dateIssued.should_not be_blank
      @i.tableOfContents.should be_blank # is placed on work instead
      @i.physicalDescriptionForm.should_not be_empty
      @i.physicalDescriptionNote.should_not be_empty
      @i.recordOriginInfo.should be_empty # is placed on work instead
      @i.languageOfCataloging.should be_empty # is placed on work instead
      @i.dateOther.should be_empty # is placed on work instead

      @w.alternativeTitle.should_not be_empty
      @w.language.should_not be_empty
      @w.identifier.should_not be_empty
      @w.note.should_not be_empty
      @i.identifier.should be_empty
      @i.note.should be_empty
    end

    it 'should place addressee on work only' do
      @w.get_relations.keys.should include 'hasAddressee'
      @i.get_relations.keys.should_not include 'hasAddressee'
    end
    it 'should only have agent/person and agent/corporation as addressee' do
      agents = @w.get_relations['hasAddressee']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place author on work only' do
      @w.get_relations.keys.should include 'hasAuthor'
      @i.get_relations.keys.should_not include 'hasAuthor'
    end
    it 'should only have agent/person and agent/corporation as author' do
      agents = @w.get_relations['hasAuthor']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place contributor on work only' do
      @w.get_relations.keys.should include 'hasContributor'
      @i.get_relations.keys.should_not include 'hasContributor'
    end
    it 'should only have agent/person and agent/corporation as contributor' do
      agents = @w.get_relations['hasContributor']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place creator on work only' do
      @w.get_relations.keys.should include 'hasCreator'
      @i.get_relations.keys.should_not include 'hasCreator'
    end
    it 'should only have agent/person and agent/corporation as creator' do
      agents = @w.get_relations['hasCreator']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place owner on work only' do
      @w.get_relations.keys.should include 'hasOwner'
      @i.get_relations.keys.should_not include 'hasOwner'
    end
    it 'should only have agent/person and agent/corporation as owner' do
      agents = @w.get_relations['hasOwner']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place patron on work only' do
      @w.get_relations.keys.should include 'hasPatron'
      @i.get_relations.keys.should_not include 'hasPatron'
    end
    it 'should only have agent/person and agent/corporation as patron' do
      agents = @w.get_relations['hasPatron']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place performer on work only' do
      @w.get_relations.keys.should include 'hasPerformer'
      @i.get_relations.keys.should_not include 'hasPerformer'
    end
    it 'should only have agent/person and agent/corporation as performer' do
      agents = @w.get_relations['hasPerformer']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place photographer on work only' do
      @w.get_relations.keys.should include 'hasPhotographer'
      @i.get_relations.keys.should_not include 'hasPhotographer'
    end
    it 'should only have agent/person and agent/corporation as photographer' do
      agents = @w.get_relations['hasPhotographer']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place printer on instance only' do
      @w.get_relations.keys.should_not include 'hasPrinter'
      @i.get_relations.keys.should include 'hasPrinter'
    end
    it 'should only have agent/person and agent/corporation as printer' do
      agents = @i.get_relations['hasPrinter']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place publisher on instance only' do
      @w.get_relations.keys.should_not include 'hasPublisher'
      @i.get_relations.keys.should include 'hasPublisher'
    end
    it 'should only have agent/person and agent/corporation as publisher' do
      agents = @i.get_relations['hasPublisher']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place scribe on instance only' do
      @w.get_relations.keys.should_not include 'hasScribe'
      @i.get_relations.keys.should include 'hasScribe'
    end
    it 'should only have agent/person and agent/corporation as scribe' do
      agents = @i.get_relations['hasScribe']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place translator on work only' do
      @w.get_relations.keys.should include 'hasTranslator'
      @i.get_relations.keys.should_not include 'hasTranslator'
    end
    it 'should only have agent/person and agent/corporation as translator' do
      agents = @w.get_relations['hasTranslator']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place digitizer on instance only' do
      @w.get_relations.keys.should_not include 'hasDigitizer'
      @i.get_relations.keys.should include 'hasDigitizer'
    end
    it 'should only have agent/person and agent/corporation as digitizer' do
      agents = @i.get_relations['hasDigitizer']
      agents.should_not be_empty
      agents.each do |agent|
        agent.type.should start_with 'agent'
      end
    end

    it 'should place topic on work only' do
      @w.get_relations.keys.should include 'hasTopic'
      @i.get_relations.keys.should_not include 'hasTopic'
    end
    it 'should all types of amus as topic' do
      amus = @w.get_relations['hasTopic']
      amus.should_not be_empty
      types = []

      amus.each do |amu|
        types << amu.type
      end
      types.should include 'agent/person'
      types.should include 'agent/organization'
      types.should include 'place'
      types.should include 'concept'
      types.should include 'event'
      types.should include 'physicalThing'
    end

    it 'should place origin on work only' do
      @w.get_relations.keys.should include 'hasOrigin'
      @i.get_relations.keys.should_not include 'hasOrigin'
    end
    it 'should only have place as origin' do
      amus = @w.get_relations['hasOrigin']
      amus.should_not be_empty
      amus.each do |amu|
        amu.type.should start_with 'place'
      end
    end

  end
end
