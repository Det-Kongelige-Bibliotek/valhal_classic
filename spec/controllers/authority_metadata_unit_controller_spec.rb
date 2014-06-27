# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AuthorityMetadataUnitsController do

  #Login a test user with admin rights
  before(:each) do
    login_admin
    AuthorityMetadataUnit.create!(:type=>AMU_TYPES.first)
  end

  after :all do
    AuthorityMetadataUnit.all.each do |amu|
      amu.delete
    end
  end

  describe "#index" do
    it 'should assign a variable with all AMUs' do
      authority_metadata_units = AuthorityMetadataUnit.all
      get :index
      assigns(:amus).should eq(authority_metadata_units)
    end
  end

  describe "#show" do
    it 'should assign a variable with the given AMU' do
      authority_metadata_unit = AuthorityMetadataUnit.create(:type=>AMU_TYPES.first, :value=>"#{DateTime.now.to_s}")
      get :show, {:id => authority_metadata_unit.pid}
      assigns(:amu).should eq(authority_metadata_unit)
    end
  end

  describe "#new" do
    it 'should assign a variable with the new AMU, but not create it yet' do
      count = AuthorityMetadataUnit.all.size
      get :new
      assigns(:amu).should_not be_blank
      AuthorityMetadataUnit.all.size.should == count
    end
  end

  describe "#edit" do
    it 'should assign a variable with the given AMU' do
      authority_metadata_unit = AuthorityMetadataUnit.create(:type=>AMU_TYPES.first, :value=>"#{DateTime.now.to_s}")
      get :edit, {:id => authority_metadata_unit.pid}
      assigns(:amu).should eq(authority_metadata_unit)
    end
  end

  describe "#create" do
    it 'should create the AMU and redirect to \'#show\'' do
      count = AuthorityMetadataUnit.all.size
      post :create, {:amu => {:type=>AMU_TYPES.first}}
      response.should redirect_to(AuthorityMetadataUnit.all.last)
      AuthorityMetadataUnit.all.size.should == count+1
    end
  end

  describe "#update" do
    it 'should be possible to update the type' do
      authority_metadata_unit = AuthorityMetadataUnit.create(:type=>AMU_TYPES.first)
      patch :update, {:id => authority_metadata_unit.pid, :amu => {:type=>AMU_TYPES.last}, :reference => {}}
      response.should redirect_to(AuthorityMetadataUnit.all.last)
      authority_metadata_unit.reload
      authority_metadata_unit.type.should == AMU_TYPES.last
      authority_metadata_unit.type.should_not == AMU_TYPES.first
    end

    it 'should be possible to update the value' do
      authority_metadata_unit = AuthorityMetadataUnit.create(:type=>AMU_TYPES.first, :value=>'Value')
      patch :update, {:id => authority_metadata_unit.pid, :amu => {:value => 'Another Value'}, :reference => {}}
      response.should redirect_to(AuthorityMetadataUnit.all.last)
      authority_metadata_unit.reload
      authority_metadata_unit.value.should == 'Another Value'
    end

    it 'should be possible to update the references' do
      authority_metadata_unit = AuthorityMetadataUnit.create(:type=>AMU_TYPES.first, :reference=>'http://reference.org')
      patch :update, {:id => authority_metadata_unit.pid, :amu => {}, :reference => {:asdf => 'http://test.org', :fdas => 'http://another_reference.org'}}
      response.should redirect_to(AuthorityMetadataUnit.all.last)
      authority_metadata_unit.reload
      authority_metadata_unit.reference.should_not be_nil
      authority_metadata_unit.reference.should_not be_empty
      authority_metadata_unit.reference.size.should == 2
      authority_metadata_unit.reference.include?('http://reference.org').should be_false
      authority_metadata_unit.reference.include?('http://test.org').should be_true
      authority_metadata_unit.reference.include?('http://another_reference.org').should be_true
    end
  end

  describe "#destroy" do
    it 'should destroy the AMU and redirect to \'#index\'' do
      authority_metadata_unit = AuthorityMetadataUnit.create(:type=>AMU_TYPES.first, :value=>"#{DateTime.now.to_s}")
      count = AuthorityMetadataUnit.all.size
      patch :destroy, {:id => authority_metadata_unit.pid }
      response.should redirect_to(authority_metadata_units_path)
      AuthorityMetadataUnit.all.size.should == count-1
    end
  end

end
