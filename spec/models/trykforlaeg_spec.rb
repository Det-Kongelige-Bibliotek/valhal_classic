require 'spec_helper'
describe Trykforlaeg do

  describe 'Save' do
    it 'should validate presence of ISBN' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.isbn = '9781934356371'
      trykforlaeg.dateIssued = '2014-10-02'
      expect(trykforlaeg.valid?).to eq true
    end

    it 'should be invalid when ISBN is absent' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.dateIssued = '2014-10-02'
      expect(trykforlaeg.valid?).to eq false
      expect(trykforlaeg.errors.size).to be == 2
    end

    it 'should validate 10 digit ISBN is correct' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.dateIssued = '2014-10-02'
      trykforlaeg.isbn = '1-84356-028-3'
      expect(trykforlaeg.valid?).to eq true
    end


    it 'should validate 13 digit ISBN is correct' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.dateIssued = '2014-10-02'
      trykforlaeg.isbn = '9781934356371'
      expect(trykforlaeg.valid?).to eq true
    end

    it 'should be invalid for an ISBN containing invalid characters' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.isbn = 'garbage'
      trykforlaeg.dateIssued = '2014-10-02'
      expect(trykforlaeg.valid?).to eq false
      expect(trykforlaeg.errors.size).to be == 1
      expect(trykforlaeg.errors.messages[:isbn][0]).to be == 'is not a valid ISBN code'
    end

    it 'should be invalid for an invalid dateIssued value' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.dateIssued = '2014-10-0'
      trykforlaeg.isbn = '9781934356371'
      expect(trykforlaeg.valid?).to eq false
      expect(trykforlaeg.errors.size).to be == 1
      expect(trykforlaeg.errors.messages[:dateIssued][0]).to be == 'date issued is an invalid EDTF format'
    end
  end
end