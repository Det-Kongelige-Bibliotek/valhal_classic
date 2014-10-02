require 'spec_helper'
describe Trykforlaeg do

  describe 'Save' do
    it 'should validate presence of ISBN' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.isbn = '9781934356371'
      trykforlaeg.valid? should_not be_falsey
    end

    it 'should be invalid when ISBN is absent' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.valid? should_not be_falsey
      expect(trykforlaeg.errors.size).to be == 2
    end

    it 'should validate 10 digit ISBN is correct' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.isbn = '1-84356-028-3'
      trykforlaeg.valid? should_not be_falsey
    end


    it 'should validate 13 digit ISBN is correct' do
      trykforlaeg = Trykforlaeg.new
      trykforlaeg.isbn = '9781934356371'
      trykforlaeg.valid? should_not be_falsey
    end

    it 'should be invalid for an ISBN containing invalid characters'
  end
end