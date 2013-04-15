require 'spec_helper'

describe "works/index" do
  before(:each) do
    assign(:works, [
      stub_model(Work),
      stub_model(Work)
    ])
  end

  it "renders a list of works" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
