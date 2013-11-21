# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "works/preservation" do
  describe 'with capybara' do
    before(:each) do
      @work = Work.create!(title: "test-#{DateTime.now.to_s}")
    end
    it 'should contain the default preservation metadata about the work.' do
      visit preservation_work_path(@work)

      page.has_text?(@work.preservation_profile)
      page.has_text?(@work.preservation_state)
      page.has_text?(@work.preservation_modify_date)
    end
  end
end