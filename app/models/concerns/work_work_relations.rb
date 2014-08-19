# -*- encoding : utf-8 -*-
module Concerns
  module WorkWorkRelations
    extend ActiveSupport::Concern

    included do
      has_many :nextInSequence, :class_name => 'ActiveFedora::Base', :property=>:next_in_sequence, :inverse_of => :previous_in_sequence
      belongs_to :previousInSequence, :class_name => 'ActiveFedora::Base', :property=>:previous_in_sequence, :inverse_of => :next_in_sequence
    end

  end
end