# -*- encoding : utf-8 -*-
require 'spec_helper'

class IntellectualEntity < ActiveFedora::Base

  delegate_to 'descMetadata', [:uuid], :unique => true

#  validates :uuid, :presence => true, :length => { :minimum => 32, :maximum => 36}

  def before_save
    self.uuid ||= UUID.new.generate
  end
end
