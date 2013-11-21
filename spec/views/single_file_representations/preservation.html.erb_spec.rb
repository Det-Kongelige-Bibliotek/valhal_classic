# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "single_file_representations/preservation" do
  describe 'with capybara' do
    before(:each) do
      @rep = SingleFileRepresentation.create!
    end
    it 'should contain the default preservation metadata about the single file representation.' do
      visit preservation_single_file_representation_path(@rep)

      page.has_text?(@rep.preservation_profile)
      page.has_text?(@rep.preservation_state)
      page.has_text?(@rep.preservation_modify_date)
    end
  end
end