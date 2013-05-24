# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do

  before do
    @user = User.new
  end

  it "should be able to set a email address" do
    @user.email = "test@kb.dk"
    @user.email.should == "test@kb.dk"
  end

  it "should be able to set a name" do
    @user.name = "test"
    @user.name.should == "test"
  end

  it "should be able to set a password" do
    @user.password = "test1234"
    @user.password.should == "test1234"
  end

  it "should be a depositor when uid is defined" do
    @user.uid = "uid:123"
    @user.depositor?.should be_true
  end

  it "should not be a admin or despositor when no attributes are set" do
    @user.admin?.should be_false
    @user.depositor?.should be_false
  end
end
