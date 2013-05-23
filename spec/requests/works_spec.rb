require 'spec_helper'

describe "Works" do
  before(:each) do
    visit 'http://localhost:3000/users/sign_in?locale=en'
    fill_in 'Username', :with => CONFIG[:test][:user]
    fill_in 'Password', :with => CONFIG[:test][:password]
    click_button 'Login'
  end

  describe "GET /works" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get works_path
      response.status.should be(200)
    end
  end
end
