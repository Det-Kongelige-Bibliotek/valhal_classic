# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "works/index" do
  before(:each) do
    assign(:works, [
      stub_model(Work),
      stub_model(Work)
    ])
  end

end
