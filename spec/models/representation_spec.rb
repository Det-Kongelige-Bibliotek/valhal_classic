# -*- encoding : utf-8 -*-
require 'spec_helper'

class Representation < ActiveFedora::Base
  include Concerns::Representation

end

describe Representation do
  describe 'Create' do
    it 'should be possible to create and save a raw representation without arguments' do
      rep = Representation.new
      rep.save.should be_true
    end

  end

  describe 'Update' do
    before do
      @rep = Representation.new
      @rep.save!
    end
  end

  describe 'Destroy' do
    before do
      @rep = Representation.new
      @rep.save!
    end
    it 'should be possible to delete a representation' do
      count = Representation.count
      @rep.destroy
      Representation.count.should == count - 1
    end
  end

  describe 'has_ie?' do
    it 'should not have an intellectual entity initially' do
      rep = Representation.create!
      rep.has_ie?.should be_false
    end

  end

  after (:all) do
    Representation.all.each { |r| r.destroy }
  end
end
