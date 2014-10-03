# -*- encoding : utf-8 -*-
shared_examples 'an element with administrative metadata' do
  let(:element) { subject }

  describe '#metadata' do
    it 'should be possible to edit the collection field' do
      element.save!
      element.collection = 'TEST'
      element.save!
      element.reload
      expect(element.collection).to be == 'TEST'
    end

    it 'should be possible to edit the activity field' do
      element.save!
      element.activity.should be_nil
      element.activity = 'TEST'
      element.save!
      element.reload
      element.activity.should == 'TEST'
    end

    it 'should be possible to edit the embargo field' do
      element.embargo.should be_nil
      element.embargo = 'TEST'
      element.save!
      element.reload
      element.embargo.should == 'TEST'
    end

    it 'should be possible to edit the embargo_date field' do
      element.save!
      element.embargo_date.should be_nil
      element.embargo_date = 'TEST'
      element.save!
      element.reload
      element.embargo_date.should == 'TEST'
    end

    it 'should be possible to edit the embargo_condition field' do
      element.save!
      element.embargo_condition.should be_nil
      element.embargo_condition = 'TEST'
      element.save!
      element.reload
      element.embargo_condition.should == 'TEST'
    end

    it 'should be possible to edit the access_condition field' do
      element.save!
      element.access_condition.should be_nil
      element.access_condition = 'TEST'
      element.save!
      element.reload
      element.access_condition.should == 'TEST'
    end

    it 'should be possible to edit the copyright field' do
      element.save!
      element.copyright.should be_nil
      element.copyright = 'TEST'
      element.save!
      element.reload
      element.copyright.should == 'TEST'
    end

    it 'should be possible to edit the material_type field' do
      element.save!
      element.material_type.should be_nil
      element.material_type = 'TEST'
      element.save!
      element.reload
      element.material_type.should == 'TEST'
    end

    it 'should be possible to edit the availability field' do
      element.save!
      element.availability.should be_nil
      element.availability = 'TEST'
      element.save!
      element.reload
      element.availability.should == 'TEST'
    end
  end
end
