require 'spec_helper'

describe 'AMUFinderService' do

  before(:all) do
    @service = AMUFinderService
  end

  after(:all) do
    AuthorityMetadataUnit.all.each do |amu|
      amu.destroy
    end
  end

  describe '#find_agents_with_relation_from_mods' do
    it 'should return a agent/person object' do
      @xml = File.read("#{Rails.root}/spec/fixtures/mods_digitized_book.xml")
      @amu = AuthorityMetadataUnit.create(:type=>'agent/person', :value=>'Klee, Frederik')
      agents = @service.find_amus_with_relation_from_mods(@xml)
      agents.should be_a(Hash)
      agents.should_not be_empty
      agents.size.should == 1
      amu = agents.keys.first
      amu.should be_a(AuthorityMetadataUnit)
      amu.type.should == @amu.type
      amu.value.should == @amu.value
      amu.pid.should == @amu.pid
      rel = agents.values.first
      rel.should be_a(Array)
      rel.should == ['Author']
    end

    it 'should return nil if there was no agent data in the MODS XML' do
      p = @service.find_amus_with_relation_from_mods(File.read("#{Rails.root}/spec/fixtures/mods_digitized_book_without_author.xml"))
      p.should be_empty
    end

    it 'should return a long list for the Valhal-mods.xml' do
      p = @service.find_amus_with_relation_from_mods(File.read("#{Rails.root}/spec/fixtures/valhal_mods.xml"))
      p.should_not be_empty
      p.values.should include ['Author']
      p.values.should include ['Contributor']
      p.values.should include ['Creator']
      p.values.should include ['Owner']
      p.values.should include ['Patron']
      p.values.should include ['Publisher']
      p.values.should include ['Photographer']
      p.values.should include ['Performer']
      p.values.should include ['Printer']
      p.values.should include ['Addressee']
      p.values.should include ['Scribe']
      p.values.should include ['Translator']
      p.values.should include ['Contributor']
      p.values.should include ['Topic']
    end

    it 'should return the origin place' do
      @xml = File.read("#{Rails.root}/spec/fixtures/mods_with_place_origin_only.xml")
      @amu = AuthorityMetadataUnit.create(:type=>'place', :value=>'Kbh')
      amus = @service.find_amus_with_relation_from_mods(@xml)
      amus.should be_a(Hash)
      amus.should_not be_empty
      amus.size.should == 1
      amu = amus.keys.first
      amu.should be_a(AuthorityMetadataUnit)
      amu.type.should == @amu.type
      amu.value.should == @amu.value
      amu.pid.should == @amu.pid
      rel = amus.values.first
      rel.should be_a(Array)
      rel.should == ['Origin']
    end

    it 'should return a long list for the Valhal-mods.xml' do
      p = @service.find_amus_with_relation_from_mods(File.read("#{Rails.root}/spec/fixtures/valhal_mods.xml"))
      p.should_not be_empty
      p.values.should include ['Topic']
      p.values.should include ['Origin']
    end
  end

  describe '#find_or_create_agent_person' do
    it 'should create new person' do
      count = AuthorityMetadataUnit.count
      @service.find_or_create_agent_person('This is a new AMU', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known person' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'Test person AMU')
      sleep 1
      p = @service.find_or_create_agent_person(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should not return an organization when requesting a person' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/organization', :value => 'Test non-person AMU')
      p = @service.find_or_create_agent_person(agent.value, nil)
      p.should_not == agent
      p.pid.should_not == agent.pid
    end
  end

  describe '#find_or_create_agent_organization' do
    it 'should create new organization' do
      count = AuthorityMetadataUnit.count
      @service.find_or_create_agent_organization('This is a new AMU', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known organization' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/organization', :value => 'Test organization AMU')
      sleep 1
      p = @service.find_or_create_agent_organization(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should not return an person when requesting a organization' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'Test non-organization AMU')
      p = @service.find_or_create_agent_organization(agent.value, nil)
      p.should_not == agent
      p.pid.should_not == agent.pid
    end
  end

  describe '#find_agent_or_create_agent_person' do
    it 'should create new person when no agent' do
      count = AuthorityMetadataUnit.count
      @service.find_agent_or_create_agent_person('find_agent_or_create_agent_person must not already exist', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known organization' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/organization', :value => 'find_agent_or_create_agent_person finds agent/organization')
      sleep 1
      p = @service.find_agent_or_create_agent_person(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should return a known person' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'find_agent_or_create_agent_person finds agent/person')
      sleep 1
      p = @service.find_agent_or_create_agent_person(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
  end

  describe '#find_or_create_concept' do
    it 'should create new concept' do
      count = AuthorityMetadataUnit.count
      @service.find_or_create_concept('This is a new concept', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known organization' do
      agent = AuthorityMetadataUnit.create(:type => 'concept', :value => 'Test concept AMU')
      sleep 1
      p = @service.find_or_create_concept(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should not return another type of AMU' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'Test AMU')
      p = @service.find_or_create_concept(agent.value, nil)
      p.should_not == agent
      p.pid.should_not == agent.pid
    end
  end

  describe '#find_or_create_event' do
    it 'should create new event' do
      count = AuthorityMetadataUnit.count
      @service.find_or_create_event('This is a new event', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known organization' do
      agent = AuthorityMetadataUnit.create(:type => 'event', :value => 'Test event AMU')
      sleep 1
      p = @service.find_or_create_event(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should not return another type of AMU' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'Test AMU')
      p = @service.find_or_create_event(agent.value, nil)
      p.should_not == agent
      p.pid.should_not == agent.pid
    end
  end

  describe '#find_or_create_physical_thing' do
    it 'should create new physicalThing' do
      count = AuthorityMetadataUnit.count
      @service.find_or_create_physical_thing('This is a new physicalThing', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known organization' do
      agent = AuthorityMetadataUnit.create(:type => 'physicalThing', :value => 'Test physicalThing AMU')
      sleep 1
      p = @service.find_or_create_physical_thing(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should not return another type of AMU' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'Test AMU')
      p = @service.find_or_create_physical_thing(agent.value, nil)
      p.should_not == agent
      p.pid.should_not == agent.pid
    end
  end

  describe '#find_or_create_place' do
    it 'should create new place' do
      count = AuthorityMetadataUnit.count
      @service.find_or_create_place('This is a new place', nil)
      AuthorityMetadataUnit.count.should == count + 1
    end
    it 'should return a known organization' do
      agent = AuthorityMetadataUnit.create(:type => 'place', :value => 'Test place AMU')
      sleep 1
      p = @service.find_or_create_place(agent.value, nil)
      p.should == agent
      p.pid.should == agent.pid
    end
    it 'should not return another type of AMU' do
      agent = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'Test AMU')
      p = @service.find_or_create_place(agent.value, nil)
      p.should_not == agent
      p.pid.should_not == agent.pid
    end
  end
end
