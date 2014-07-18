# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InstanceHelper do
  include InstanceHelper
  before(:each) do
    @instance = SingleFileInstance.create
    @amu = AuthorityMetadataUnit.create(:type => 'agent/person', :value => 'InstanceHelper test amu')
  end

  after :all do
    AuthorityMetadataUnit.all.each {|amu| amu.destroy}
  end

  describe '#add_agent' do
    it 'should not do anything, when the list is empty' do
      add_agents([], @instance)
      @instance.get_relations.should be_empty
    end

    it 'should be possible to add topic' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasTopic'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasTopic'].should_not be_empty
    end

    it 'should be possible to add origin' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasOrigin'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasOrigin'].should_not be_empty
    end

    it 'should be possible to add contributor' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasContributor'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasContributor'].should_not be_empty
    end

    it 'should be possible to add owner' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasOwner'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasOwner'].should_not be_empty
    end

    it 'should be possible to add printer' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasPatron'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasPatron'].should_not be_empty
    end

    it 'should be possible to add printer' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasPrinter'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasPrinter'].should_not be_empty
    end

    it 'should be possible to add publisher' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasPublisher'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasPublisher'].should_not be_empty
    end

    it 'should be possible to add scribe' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasScribe'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasScribe'].should_not be_empty
    end

    it 'should be possible to add digitizer' do
      add_agents([[[{}, {'agentID' => @amu.pid, 'relationshipType' => 'hasDigitizer'}]]], @instance)
      @instance.get_relations.should_not be_empty
      @instance.get_relations['hasDigitizer'].should_not be_empty
    end
  end
end
