require 'spec_helper'

describe Place do
  after :all do
    AuthorityMetadataUnit.all.each do |amu|
      amu.delete
    end
  end

  it 'should be possible to create a person with values in all fields' do
    p = Place.create(:name => 'test')
    p.should_not be_nil
    p.type.should == 'place'
    p.name.should == 'test'
  end

  describe "#delete" do
    before :each do
      @p = Place.create!(:name => 'test')

    end

    it 'should be possible to delete an AMU' do
      @p.save!.should be_true
      @p.delete!.should be_true
    end
  end

  describe "#update" do
    it 'should be possible to update all fields' do
      p = Place.create(:name => 'test')

      p.name = 'test2'

      p.save
      p.reload

      p.name.should == 'test2'
    end
  end
end  