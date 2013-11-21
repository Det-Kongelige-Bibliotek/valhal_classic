# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "ordered_representations/preservation" do
  describe 'with capybara' do
    before(:each) do
      @rep = OrderedRepresentation.create!
    end
    it 'should contain the default preservation metadata about the ordered representation.' do
      visit preservation_ordered_representation_path(@rep)

      page.has_text?(@rep.preservation_profile)
      page.has_text?(@rep.preservation_state)
      page.has_text?(@rep.preservation_modify_date)
    end
  end
end