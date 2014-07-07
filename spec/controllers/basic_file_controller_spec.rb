# -*- encoding : utf-8 -*-
require 'spec_helper'
include WorkHelper

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BasicFilesController do
  #Login a test user with admin rights
  before(:each) do
    login_admin
  end

  describe 'GET show' do
    it 'assigns the requested file as @file' do
      file = create_basic_file(nil)
      get :show, {:id =>file.to_param}
      assigns(:file).should eq(file)
    end
  end

  describe 'GET download' do
    it 'should be possible to download the file' do
      file = create_basic_file(nil)
      get :download, {:id => file.pid}
      response.status.should == 200
    end

    it 'should give a 404 error when pointing to non-existing id' do
      file = create_basic_file(nil)
      id = "#{file.pid}#{DateTime.now.to_i}" # non-existing id
      get :download, {:id => id}
      response.status.should == 404
    end

    it 'should give a 500 error when wrong id format' do
      file = create_basic_file(nil)
      id = "#{file.pid}+#{DateTime.now.to_s}" # wrong id format
      get :download, {:id => id}
      response.status.should == 500
    end
  end

  describe 'Update preservation profile metadata' do
    before(:each) do
      @file = create_basic_file(nil)
    end
    it 'should have a default preservation settings' do
      b = BasicFile.find(@file.pid)
      b.preservation_profile.should_not be_blank
      b.preservation_state.should_not be_blank
      b.preservation_details.should_not be_blank
      b.preservation_modify_date.should_not be_blank
      b.preservation_comment.should be_blank
    end

    it 'should be updated and redirect to the file' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @file.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@file)

      b = BasicFile.find(@file.pid)
      b.preservation_state.should_not be_blank
      b.preservation_details.should_not be_blank
      b.preservation_modify_date.should_not be_blank
      b.preservation_profile.should == profile
      b.preservation_comment.should == comment
    end

    it 'should not update or redirect, when the profile is wrong.' do
      profile = "wrong profile #{Time.now.to_s}"
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @file.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should_not redirect_to(@file)

      b = BasicFile.find(@file.pid)
      b.preservation_state.should_not be_blank
      b.preservation_details.should_not be_blank
      b.preservation_modify_date.should_not be_blank
      b.preservation_profile.should_not == profile
      b.preservation_comment.should_not == comment
    end

    it 'should update the preservation date' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      comment = "This is the preservation comment"
      b = BasicFile.find(@file.pid)
      d = b.preservation_modify_date

      put :update_preservation_profile, {:id => @file.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@file)

      b = BasicFile.find(@file.pid)
      b.preservation_modify_date.should_not == d
    end

    it 'should not update the preservation date, when the same profile and comment is given.' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      comment = "This is the preservation comment"
      @file.preservation_profile = profile
      @file.preservation_comment = comment
      @file.save

      b = BasicFile.find(@file.pid)
      d = b.preservation_modify_date

      put :update_preservation_profile, {:id => @file.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@file)

      b = BasicFile.find(@file.pid)
      b.preservation_modify_date.should == d
    end

    it 'should send a message, when performing preservation and the profile has Yggdrasil set to true' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      PRESERVATION_CONFIG['preservation_profile'][profile]['yggdrasil'].should == 'true'
      comment = "This is the preservation comment"
      destination = MQ_CONFIG["preservation"]["destination"]
      uri = MQ_CONFIG["mq_uri"]

      conn = Bunny.new(uri)
      conn.start

      ch = conn.create_channel
      q = ch.queue(destination, :durable => true)

      put :update_preservation_profile, {:id => @file.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@file)

      q.subscribe do |delivery_info, metadata, payload|
        metadata[:type].should == Constants::MQ_MESSAGE_TYPE_PRESERVATION_REQUEST
        payload.should include @file.pid
        json = JSON.parse(payload)
        json.keys.should include ('UUID')
        json.keys.should include ('Preservation_profile')
        json.keys.should include ('Valhal_ID')
        json.keys.should include ('File_UUID')
        json.keys.should include ('Content_URI')
        json.keys.should include ('Model')
        json.keys.should include ('metadata')
        json['metadata'].keys.each do |k|
          @file.datastreams.keys.should include k
          Constants::NON_RETRIEVABLE_DATASTREAM_NAMES.should_not include k
        end
      end

      b = BasicFile.find(@file.pid)
      b.preservation_state.should == Constants::PRESERVATION_STATE_INITIATED.keys.first
      b.preservation_comment.should == comment
      sleep 1.seconds
      conn.close
    end

    it 'should not send a message, when performing preservation and the profile has Yggdrasil set to false' do
      profile = PRESERVATION_CONFIG['preservation_profile'].keys.first
      PRESERVATION_CONFIG['preservation_profile'][profile]['yggdrasil'].should == 'false'
      comment = 'This is the preservation comment'

      put :update_preservation_profile, {:id => @file.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON,
                                         :preservation => {:preservation_profile => profile,
                                                           :preservation_comment => comment }}
      response.should redirect_to(@file)

      b = BasicFile.find(@file.pid)
      b.preservation_state.should == Constants::PRESERVATION_STATE_NOT_LONGTERM.keys.first
      b.preservation_comment.should == comment
    end

    it 'should not send inheritable settings upwards' do
      rep = SingleFileRepresentation.new
      rep.files << @file
      rep.save!
      @file.save!

      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @file.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON, :preservation =>
          {:preservation_profile => profile, :preservation_comment => comment, :preservation_inheritance => '1'}}

      b = BasicFile.find(@file.pid)
      b.preservation_state.should_not be_blank
      b.preservation_details.should_not be_blank
      b.preservation_modify_date.should_not be_blank
      b.preservation_profile.should == profile
      b.preservation_comment.should == comment

      rep = SingleFileRepresentation.find(rep.pid)
      rep.preservation_state.should_not be_blank
      rep.preservation_details.should_not be_blank
      rep.preservation_modify_date.should_not be_blank
      rep.preservation_profile.should_not == profile
      rep.preservation_comment.should_not == comment
    end
  end

  describe 'GET preservation' do
    it 'should assign \'@file\' to the file' do
      @file = create_basic_file(nil)
      get :preservation, {:id => @file.pid}
      assigns(:file).should eq(@file)
    end
  end

  after(:all) do
    BasicFile.all.each { |file| file.delete }
  end
end
