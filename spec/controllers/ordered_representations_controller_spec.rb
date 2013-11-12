# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OrderedRepresentationsController do
  #Login a test user with admin rights
  before(:each) do
    login_admin
  end

  # This should return the minimal set of attributes required to create a valid
  # OrderedRepresentation. As you add validations to OrderedRepresentation, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrderedRepresentationsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe 'GET show' do
    it 'assigns the requested ordered_representation as @ordered_representation' do
      ordered_representation = OrderedRepresentation.create! valid_attributes
      get :show, {:id => ordered_representation.to_param}, valid_session
      assigns(:ordered_representation).should eq(ordered_representation)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested ordered_representation as @ordered_representation' do
      ordered_representation = OrderedRepresentation.create! valid_attributes
      get :edit, {:id => ordered_representation.to_param}, valid_session
      assigns(:ordered_representation).should eq(ordered_representation)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested ordered_representation' do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        # Assuming there are no other ordered_representations in the database, this
        # specifies that the OrderedRepresentation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        OrderedRepresentation.any_instance.should_receive(:update_attributes).with({ 'these' => 'params' })
        put :update, {:id => ordered_representation.to_param, :ordered_representation => { 'these' => 'params' }}, valid_session
      end

      it 'assigns the requested ordered_representation as @ordered_representation' do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        put :update, {:id => ordered_representation.to_param, :ordered_representation => valid_attributes}, valid_session
        assigns(:ordered_representation).should eq(ordered_representation)
      end

      it 'redirects to the ordered_representation' do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        put :update, {:id => ordered_representation.to_param, :ordered_representation => valid_attributes}, valid_session
        response.should redirect_to(ordered_representation)
      end
    end

    describe 'with invalid params' do
      it 'assigns the ordered_representation as @ordered_representation' do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrderedRepresentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => ordered_representation.to_param, :ordered_representation => {  }}, valid_session
        assigns(:ordered_representation).should eq(ordered_representation)
      end

      it 're-renders the \'edit\' template' do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrderedRepresentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => ordered_representation.to_param, :ordered_representation => {  }}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'GET thumbnail_url' do
    it 'should return the thumbnail image' do
      rep = OrderedRepresentation.create!
      @tiff1 = ActionDispatch::Http::UploadedFile.new(filename: 'first.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      tiff_file = TiffFile.create!
      tiff_file.add_file(@tiff1)

      get :thumbnail_url, {:pid => tiff_file.pid, :id => rep.pid}
      response.response_code.should == 200
    end

    it 'should return 404 when no pid' do
      rep = OrderedRepresentation.create!

      get :thumbnail_url, {:pid => nil, :id => rep.pid}
      response.response_code.should == 404
    end

    it 'should return 404 when no pid' do
      rep = OrderedRepresentation.create!
      rep.save!

      get :thumbnail_url, {:pid => rep.pid, :id => rep.pid}
      response.response_code.should == 404
    end
  end

  describe 'GET download_all' do
    it 'should respond with a empty zip basic_files' do
      pending "Failing... "
      rep = OrderedRepresentation.create!

      get :download_all, {:id => rep.pid}
      response.response_code.should == 200
      response.content_type.should == 'application/zip'
      # TODO empty zip-basic_files has size 22. Figure out a better way of validating that it is empty.
      response.body.length.should == 22

    end

    it 'should deliver a zip basic_files of smaller size than the basic_files within' do
      pending "Failing... "
      rep = OrderedRepresentation.create!
      @tiff1 = ActionDispatch::Http::UploadedFile.new(filename: 'first.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      tiff_file = TiffFile.create!
      tiff_file.add_file(@tiff1)
      rep.files << tiff_file
      rep.save!

      get :download_all, {:id => rep.pid}
      response.response_code.should == 200
      response.content_type.should == 'application/zip'
      response.body.length.should < tiff_file.size
      # TODO empty zip-basic_files has size 22. Figure out a better way of validating that the basic_files is not empty.
      response.body.length.should > 22
    end
  end

  describe 'Update preservation profile metadata' do
    before(:each) do
      @rep = OrderedRepresentation.create!
    end
    it 'should have a default preservation settings' do
      rep = OrderedRepresentation.find(@rep.pid)
      rep.preservation_profile.should_not be_blank
      rep.preservation_state.should_not be_blank
      rep.preservation_details.should_not be_blank
      rep.preservation_modify_date.should_not be_blank
      rep.preservation_comment.should be_blank
    end

    it 'should be updated and redirect to the ordered representation' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      rep = OrderedRepresentation.find(@rep.pid)
      rep.preservation_state.should_not be_blank
      rep.preservation_details.should_not be_blank
      rep.preservation_modify_date.should_not be_blank
      rep.preservation_profile.should == profile
      rep.preservation_comment.should == comment
    end

    it 'should not update or redirect, when the profile is wrong.' do
      profile = "wrong profile #{Time.now.to_s}"
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should_not redirect_to(@rep)

      rep = OrderedRepresentation.find(@rep.pid)
      rep.preservation_state.should_not be_blank
      rep.preservation_details.should_not be_blank
      rep.preservation_modify_date.should_not be_blank
      rep.preservation_profile.should_not == profile
      rep.preservation_comment.should_not == comment
    end

    it 'should update the preservation date' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      rep = OrderedRepresentation.find(@rep.pid)
      d = rep.preservation_modify_date

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      rep = OrderedRepresentation.find(@rep.pid)
      rep.preservation_modify_date.should_not == d
    end

    it 'should not update the preservation date, when the same profile and comment is given.' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      @rep.preservation_profile = profile
      @rep.preservation_comment = comment
      @rep.save

      rep = OrderedRepresentation.find(@rep.pid)
      d = rep.preservation_modify_date

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      rep = OrderedRepresentation.find(@rep.pid)
      rep.preservation_modify_date.should == d
    end

    it 'should send a message, when performing preservation' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      destination = MQ_CONFIG["preservation"]["destination"]
      uri = MQ_CONFIG["mq_uri"]

      conn = Bunny.new(uri)
      conn.start

      ch = conn.create_channel
      q = ch.queue(destination, :durable => true)

      put :update_preservation_profile, {:id => @rep.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      q.subscribe do |delivery_info, metadata, payload|
        payload.should include @rep.pid
        json = JSON.parse(payload)
        json.keys.should include ('UUID')
        json.keys.should include ('Preservation_profile')
        json.keys.should include ('Update_URI')
        json.keys.should_not include ('File_UUID')
        json.keys.should_not include ('Content_URI')
        json.keys.should include ('metadata')
        json['metadata'].keys.each do |k|
          @rep.datastreams.keys.should include k
          Constants::NON_RETRIEVABLE_DATASTREAM_NAMES.should_not include k
        end
      end

      rep = OrderedRepresentation.find(@rep.pid)
      rep.preservation_state.should == Constants::PRESERVATION_STATE_INITIATED.keys.first
      rep.preservation_comment.should == comment
      sleep 1.second
      conn.close
    end
  end

  describe 'Update preservation state metadata' do
    before(:each) do
      @rep = OrderedRepresentation.create!
    end
    it 'should be updated and redirect to the ordered representation' do
      state = "TheNewState-#{Time.now.to_s}"
      details = "Any details will suffice."

      post :update_preservation_metadata, {:id => @rep.pid, :preservation => {:preservation_state => state, :preservation_details => details }}
      response.status.should == 200

      orep = OrderedRepresentation.find(@rep.pid)
      orep.preservation_state.should == state
      orep.preservation_details.should == details
      orep.preservation_modify_date.should_not be_blank
      orep.preservation_profile.should_not be_blank
    end

    it 'should change the values when updating' do
      old_state = "TheOldState-#{Time.now.to_s}"
      new_state = "tHEnEWsTATE-#{Time.now.to_s}"
      old_details = "Any details will suffice."
      new_details = "No details are accepted!"

      orep = OrderedRepresentation.find(@rep.pid)
      orep.preservation_state = old_state
      orep.preservation_details = old_details
      orep.save!

      d = orep.preservation_modify_date

      orep = OrderedRepresentation.find(@rep.pid)
      orep.preservation_state.should == old_state
      orep.preservation_state.should_not == new_state
      orep.preservation_details.should == old_details
      orep.preservation_details.should_not == new_details

      post :update_preservation_metadata, {:id => @rep.pid, :preservation => {:preservation_state => new_state, :preservation_details => new_details }}
      response.status.should == 200

      orep = OrderedRepresentation.find(@rep.pid)
      orep.preservation_state.should == new_state
      orep.preservation_state.should_not == old_state
      orep.preservation_details.should == new_details
      orep.preservation_details.should_not == old_details
      orep.preservation_modify_date.should_not == d
    end

    it 'should not update when same values' do
      state = "TheState-#{Time.now.to_s}"
      details = "TheDetails-#{Time.now.to_s}"

      orep = OrderedRepresentation.find(@rep.pid)
      orep.preservation_state = state
      orep.preservation_details = details
      orep.save!

      d = orep.preservation_modify_date

      post :update_preservation_metadata, {:id => @rep.pid, :preservation => {:preservation_state => state, :preservation_details => details }}
      response.status.should == 200

      orep = OrderedRepresentation.find(@rep.pid)
      orep.preservation_state.should == state
      orep.preservation_details.should == details
      orep.preservation_modify_date.should == d
    end

    it 'should be able to update only the warc id' do
      warc_id = "WarcId-#{Time.now.to_s}"

      b = OrderedRepresentation.find(@rep.pid)
      state = b.preservation_state
      details = b.preservation_details
      b.save!

      d = b.preservation_modify_date

      post :update_preservation_metadata, {:id => @rep.pid, :preservation => {:warc_id => warc_id}}
      response.status.should == 200

      b = OrderedRepresentation.find(@rep.pid)
      b.preservation_state.should == state
      b.preservation_details.should == details
      b.warc_id.should == warc_id
      b.preservation_modify_date.should_not == d
    end

    it 'should give a 400 error response, if the message is incomplete' do
      post :update_preservation_metadata, {:id => @rep.pid}
      response.status.should == 400
    end

    it 'should give a 404 error response, if the message is pointing to non-existing file' do
      id = "#{@rep.pid}#{DateTime.now.to_i}" # non-existing id
      post :update_preservation_metadata, {:id => id, :preservation => {:warc_id => "warc_id"}}
      response.status.should == 404
    end

    it 'should give a 500 error response, if the message contains incorrect id' do
      id = "#{@rep.pid}+#{DateTime.now.to_s}" # wrong id format
      post :update_preservation_metadata, {:id => id, :preservation => {:warc_id => "warc_id"}}
      response.status.should == 500
    end
  end
end
