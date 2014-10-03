# -*- encoding : utf-8 -*-
shared_examples 'an instance' do
  let(:ins) { subject }

  describe 'Create' do
    it 'should be possible to save a new instance without any parameters' do
      expect(ins.save).to be == true
    end
  end

  describe 'Destroy' do
    it 'should be possible to delete a instance' do
      ins.save!
      expect(ins.destroy).to include('\"status\"=>0')
    end
  end

  describe 'has_ie?' do
    it 'should not have an intellectual entity initially' do
      ins.save!
      expect(ins.has_ie?).to be == false
    end
  end

  describe '#metadata' do
    it 'should be possible to edit the shelfLocator field' do
      ins.save!
      ins.shelfLocator.should be_nil
      ins.shelfLocator = 'TEST'
      ins.save!
      ins.reload
      ins.shelfLocator.should == 'TEST'
    end

    it 'should be possible to edit the physicalDescriptionForm field' do
      ins.save!
      ins.physicalDescriptionForm.should be_empty
      ins.physicalDescriptionForm = 'TEST'
      ins.save!
      ins.reload
      ins.physicalDescriptionForm.should == ['TEST']
    end

    it 'should be possible to edit the physicalDescriptionNote field' do
      ins.physicalDescriptionNote.should be_empty
      ins.physicalDescriptionNote = 'TEST'
      ins.save!
      ins.reload
      ins.physicalDescriptionNote.should == ['TEST']
    end

    it 'should be possible to edit the languageOfCataloging field' do
      ins.save!
      ins.languageOfCataloging.should be_empty
      ins.languageOfCataloging = 'TEST'
      ins.save!
      ins.reload
      ins.languageOfCataloging.should == ['TEST']
    end

    it 'should be possible to edit the dateCreated field' do
      ins.save!
      ins.dateCreated.should be_nil
      ins.dateCreated = 'TEST'
      ins.save!
      ins.reload
      ins.dateCreated.should == 'TEST'
    end

    it 'should be possible to edit the dateIssued field' do
      ins.save!
      ins.dateIssued.should be_nil
      ins.dateIssued = 'TEST'
      ins.save!
      ins.reload
      ins.dateIssued.should == 'TEST'
    end

    it 'should be possible to edit the dateOther field' do
      ins.save!
      ins.dateOther.should be_empty
      ins.dateOther = 'TEST'
      ins.save!
      ins.reload
      ins.dateOther.should == ['TEST']
    end

    it 'should be possible to edit the recordOriginInfo field' do
      ins.save!
      ins.recordOriginInfo.should be_empty
      ins.recordOriginInfo = 'TEST'
      ins.save!
      ins.reload
      ins.recordOriginInfo.should == ['TEST']
    end

    it 'should be possible to edit the tableOfContents field' do
      ins.save!
      ins.tableOfContents.should be_nil
      ins.tableOfContents = 'TEST'
      ins.save!
      ins.reload
      ins.tableOfContents.should == 'TEST'
    end

    it 'should be possible to edit the identifier objects' do
      ins.save!
      ins.identifier.should be_empty
      ins.identifier=[{'value' =>'Identifier value'}, {'value' => 'Another identifier with displayLabel', 'displayLabel' => 'DisplayLabel of identifier'}]
      ins.save!
      ins.reload
      ins.identifier.should_not be_empty
      ins.identifier.size.should == 2
      ins.identifier=[]
      ins.identifier.should be_empty
    end

    it 'should be possible to edit the note objects' do
      ins.save!
      ins.note.should be_empty
      ins.note=[{'value' =>'Note value'},{'value' => 'Another note with displayLabel', 'displayLabel' => 'DisplayLabel of note'}]
      ins.save!
      ins.reload
      ins.note.should_not be_empty
      ins.note.size.should == 2
      ins.note=[]
      ins.note.should be_empty
    end
  end
end
