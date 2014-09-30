# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AuthorityMetadataUnit do
  after :all do
    AuthorityMetadataUnit.all.each do |amu|
      amu.delete
    end
  end

  describe "#create" do
    it 'should be possible to create a AMU with values in all field' do
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first, :value=>'Value', :reference=>'Reference')
      amu.should_not be_nil
      amu.type.should == AMU_TYPES.first
      amu.value.should == 'Value'
    end

    it 'should be possible to create a AMU with no value or reference' do
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first, :value=>nil, :reference=>nil)
      amu.should_not be_nil
      amu.type.should_not be_nil
      amu.value.should be_nil
      amu.reference.should be_empty
    end
  end

  describe "#delete" do
    before :each do
      @amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
    end

    it 'should be possible to delete an AMU' do
      @amu.save.should be_truthy
      @amu.delete.should be_truthy
    end
  end

  describe "#update" do
    it 'should be possible to change the type field' do
      pending
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
      amu.type.should == AMU_TYPES.first

      amu.type = AMU_TYPES.last
      amu.save!
      amu.reload
      amu.type.should_not == AMU_TYPES.first
      amu.type.should == AMU_TYPES.last
    end

    it 'should be possible to change the value field' do
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
      amu.value.should be_nil

      amu.value = 'Value'
      amu.save!
      amu.reload
      amu.value.should == 'Value'
    end

    it 'should be possible to add a reference' do
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
      amu.reference.should be_empty

      amu.reference = 'Reference'
      amu.save!
      amu.reload
      amu.reference.should == ['Reference']
    end

    it 'should be possible to add a reference' do
      amu = AuthorityMetadataUnit.create(:reference=>'Reference', :type=>AMU_TYPES.first)
      amu.reference.should_not be_empty
      amu.reference.should == ['Reference']

      amu.reference = nil
      amu.save!
      amu.reload
      amu.reference.should be_empty
    end
  end

  describe '#get_relations' do
    it 'should initially be empty' do
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
      amu.get_relations.should be_empty
    end
    it 'should be possible to extract all the relations' do
      amu = AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
      i = SingleFileInstance.create!
      amu.isTopicOf << i
      amu.save!
      i.save!
      amu.reload
      amu.get_relations.should_not be_empty
      amu.get_relations.keys.should include ('isTopicOf')
      amu.get_relations.values.should include ([i])
    end
  end

end
