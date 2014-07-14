# -*- encoding : utf-8 -*-
require 'spec_helper'

class Instance < ActiveFedora::Base
  include Concerns::Instance

end

describe Instance do
  describe 'Create' do
    it 'should be possible to create and save a raw instance without arguments' do
      ins = Instance.new
      ins.save.should be_true
    end

  end

  describe 'Update' do
    before do
      @ins = Instance.new
      @ins.save!
    end
  end

  describe 'Destroy' do
    before do
      @ins = Instance.new
      @ins.save!
    end
    it 'should be possible to delete a instance' do
      count = Instance.count
      @ins.destroy
      Instance.count.should == count - 1
    end
  end

  describe 'has_ie?' do
    it 'should not have an intellectual entity initially' do
      ins = Instance.create!
      ins.has_ie?.should be_false
    end

  end

  after (:all) do
    Instance.all.each { |r| r.destroy }
  end
end
