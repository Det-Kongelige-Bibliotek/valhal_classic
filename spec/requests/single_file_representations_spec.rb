require 'spec_helper'

describe "SingleFileRepresentations" do
  describe "GET /single_file_representations" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get single_file_representations_path
      response.status.should be(200)
    end
  end
end
