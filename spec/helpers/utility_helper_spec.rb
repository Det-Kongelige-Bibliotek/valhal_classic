# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UtilityHelper do

  describe '#contentless_array?' do
    it 'should accept a nil' do
      contentless_array?(nil).should be_true
    end

    it 'should accept an empty array' do
      contentless_array?([]).should be_true
    end

    it 'should accept an array with a empty string' do
      contentless_array?(['']).should be_true
    end

    it 'should accept an array with several empty strings' do
      contentless_array?(['', '', ""]).should be_true
    end

    it 'should reject an array with a non-empty string' do
      contentless_array?(['TESTING']).should be_false
    end

    it 'should reject an array with both a non-empty string and a empty string' do
      contentless_array?(['', 'TESTING']).should be_false
    end
  end

  describe '#get_controlled_vocab?' do
    it 'should return an empty array if the controlled vocabulary does not exist'  do
      get_controlled_vocab('my_test_vocab').size.should be 0
    end
  end
end
