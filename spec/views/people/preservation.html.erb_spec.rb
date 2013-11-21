# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "people/preservation" do
  describe 'with capybara' do
    before(:each) do
      @person = Person.create!(firstname: "test-#{DateTime.now.to_s}", lastname: "test-#{DateTime.now.to_s}")
    end
    it 'should contain the default preservation metadata about the person.' do
      visit preservation_person_path(@person)

      page.has_text?(@person.preservation_profile)
      page.has_text?(@person.preservation_state)
      page.has_text?(@person.preservation_modify_date)
    end
  end
end