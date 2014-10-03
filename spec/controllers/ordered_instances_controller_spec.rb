# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OrderedInstancesController do
  #Login a test user with admin rights
  before(:each) do
    login_admin
  end

  # This should return the minimal set of attributes required to create a valid
  # OrderedInstance. As you add validations to OrderedInstance, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OrderedInstancesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe 'GET show' do
    it 'assigns the requested ordered_instance as @ordered_instance' do
      ordered_instance = OrderedInstance.create! valid_attributes
      get :show, {:id => ordered_instance.to_param}, valid_session
      assigns(:ordered_instance).should eq(ordered_instance)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested ordered_instance as @ordered_instance' do
      ordered_instance = OrderedInstance.create! valid_attributes
      get :edit, {:id => ordered_instance.to_param}, valid_session
      assigns(:ordered_instance).should eq(ordered_instance)
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested ordered_instance' do
        ordered_instance = OrderedInstance.create! valid_attributes
        # Assuming there are no other ordered_instances in the database, this
        # specifies that the OrderedInstance created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        OrderedInstance.any_instance.should_receive(:update_attributes).with({ 'these' => 'params' })
        put :update, {:id => ordered_instance.to_param, :ordered_instance => { 'these' => 'params' }}, valid_session
      end

      it 'assigns the requested ordered_instance as @ordered_instance' do
        ordered_instance = OrderedInstance.create! valid_attributes
        put :update, {:id => ordered_instance.to_param, :ordered_instance => valid_attributes}, valid_session
        assigns(:ordered_instance).should eq(ordered_instance)
      end

      it 'redirects to the ordered_instance' do
        ordered_instance = OrderedInstance.create! valid_attributes
        put :update, {:id => ordered_instance.to_param, :ordered_instance => valid_attributes}, valid_session
        response.should redirect_to(ordered_instance)
      end
    end

    describe 'with invalid params' do
      it 'assigns the ordered_instance as @ordered_instance' do
        ordered_instance = OrderedInstance.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrderedInstance.any_instance.stub(:save).and_return(false)
        put :update, {:id => ordered_instance.to_param, :ordered_instance => {  }}, valid_session
        assigns(:ordered_instance).should eq(ordered_instance)
      end

      it 're-renders the \'edit\' template' do
        ordered_instance = OrderedInstance.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrderedInstance.any_instance.stub(:save).and_return(false)
        put :update, {:id => ordered_instance.to_param, :ordered_instance => {  }}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'GET thumbnail_url' do
    it 'should return the thumbnail image' do
      ins = OrderedInstance.create!
      @tiff1 = ActionDispatch::Http::UploadedFile.new(filename: 'first.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      tiff_file = TiffFile.create!
      tiff_file.add_file(@tiff1, '1')

      get :thumbnail_url, {:pid => tiff_file.pid, :id => ins.pid}
      response.response_code.should == 200
    end

    it 'should return 404 when no pid' do
      ins = OrderedInstance.create!

      get :thumbnail_url, {:pid => nil, :id => ins.pid}
      response.response_code.should == 404
    end

    it 'should return 404 when no pid' do
      ins = OrderedInstance.create!
      ins.save!

      get :thumbnail_url, {:pid => ins.pid, :id => ins.pid}
      response.response_code.should == 404
    end
  end

  describe 'GET download_all' do
    it 'should respond with a empty zip basic_files' do
      pending "Failing... "
      ins = OrderedInstance.create!

      get :download_all, {:id => ins.pid}
      response.response_code.should == 200
      response.content_type.should == 'application/zip'
      # TODO empty zip-basic_files has size 22. Figure out a better way of validating that it is empty.
      response.body.length.should == 22

    end

    it 'should deliver a zip basic_files of smaller size than the basic_files within' do
      pending "Failing... "
      ins = OrderedInstance.create!
      @tiff1 = ActionDispatch::Http::UploadedFile.new(filename: 'first.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))
      tiff_file = TiffFile.create!
      tiff_file.add_file(@tiff1, '1')
      ins.files << tiff_file
      ins.save!

      get :download_all, {:id => ins.pid}
      response.response_code.should == 200
      response.content_type.should == 'application/zip'
      response.body.length.should < tiff_file.size
      # TODO empty zip-basic_files has size 22. Figure out a better way of validating that the basic_files is not empty.
      response.body.length.should > 22
    end
  end

  describe 'Update preservation profile metadata' do
    before(:each) do
      @ins = OrderedInstance.create!
    end
    it 'should have a default preservation settings' do
      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_profile.should_not be_blank
      ins.preservation_state.should_not be_blank
      ins.preservation_details.should_not be_blank
      ins.preservation_modify_date.should_not be_blank
      ins.preservation_comment.should be_blank
    end

    it 'should be updated and redirect to the ordered instance' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @ins.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@ins)

      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_state.should_not be_blank
      ins.preservation_details.should_not be_blank
      ins.preservation_modify_date.should_not be_blank
      ins.preservation_profile.should == profile
      ins.preservation_comment.should == comment
    end

    it 'should not update or redirect, when the profile is wrong.' do
      profile = "wrong profile #{Time.now.to_s}"
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @ins.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should_not redirect_to(@ins)

      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_state.should_not be_blank
      ins.preservation_details.should_not be_blank
      ins.preservation_modify_date.should_not be_blank
      ins.preservation_profile.should_not == profile
      ins.preservation_comment.should_not == comment
    end

    it 'should update the preservation date' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      comment = "This is the preservation comment"
      ins = OrderedInstance.find(@ins.pid)
      d = ins.preservation_modify_date

      put :update_preservation_profile, {:id => @ins.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@ins)

      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_modify_date.should_not == d
    end

    it 'should not update the preservation date, when the same profile and comment is given.' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      comment = "This is the preservation comment"
      @ins.preservation_profile = profile
      @ins.preservation_comment = comment
      @ins.save

      ins = OrderedInstance.find(@ins.pid)
      d = ins.preservation_modify_date

      put :update_preservation_profile, {:id => @ins.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@ins)

      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_modify_date.should == d
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

      put :update_preservation_profile, {:id => @ins.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@ins)

      q.subscribe do |delivery_info, metadata, payload|
        metadata[:type].should == Constants::MQ_MESSAGE_TYPE_PRESERVATION_REQUEST
        payload.should include @ins.pid
        json = JSON.parse(payload)
        json.keys.should include ('UUID')
        json.keys.should include ('Preservation_profile')
        json.keys.should include ('Valhal_ID')
        json.keys.should_not include ('File_UUID')
        json.keys.should_not include ('Content_URI')
        json.keys.should include ('Model')
        json.keys.should include ('metadata')
        json['metadata'].keys.each do |k|
          @ins.datastreams.keys.should include k
          Constants::NON_RETRIEVABLE_DATASTREAM_NAMES.should_not include k
        end
      end

      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_state.should == Constants::PRESERVATION_STATE_INITIATED.keys.first
      ins.preservation_comment.should == comment
      sleep 1.second
      conn.close
    end

    it 'should not send a message, when performing preservation and the profile has Yggdrasil set to false' do
      profile = PRESERVATION_CONFIG['preservation_profile'].keys.first
      PRESERVATION_CONFIG['preservation_profile'][profile]['yggdrasil'].should == 'false'
      comment = 'This is the preservation comment'

      put :update_preservation_profile, {:id => @ins.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON,
                                         :preservation => {:preservation_profile => profile,
                                                           :preservation_comment => comment }}
      response.should redirect_to(@ins)

      ins = OrderedInstance.find(@ins.pid)
      ins.preservation_state.should == Constants::PRESERVATION_STATE_NOT_LONGTERM.keys.first
      ins.preservation_comment.should == comment
    end

    it 'should send inheritable settings to the files' do
      file = create_basic_file(nil)
      @ins.files << file
      @ins.save!
      file.save!

      profile = PRESERVATION_CONFIG["preservation_profile"].keys.last
      comment = "This is the preservation comment-#{Time.now.to_s}"

      put :update_preservation_profile, {:id => @ins.pid, :commit => Constants::PERFORM_PRESERVATION_BUTTON, :preservation =>
          {:preservation_profile => profile, :preservation_comment => comment, :preservation_inheritance => '1'}}

      bf = BasicFile.find(file.pid)
      bf.preservation_state.should_not be_blank
      bf.preservation_details.should_not be_blank
      bf.preservation_modify_date.should_not be_blank
      bf.preservation_profile.should == profile
      bf.preservation_comment.should == comment

      ins = SingleFileInstance.find(@ins.pid)
      ins.preservation_state.should_not be_blank
      ins.preservation_details.should_not be_blank
      ins.preservation_modify_date.should_not be_blank
      ins.preservation_profile.should == profile
      ins.preservation_comment.should == comment
    end
  end

  describe 'GET preservation' do
    it 'should assign \'@ins\' to the ordered_instance' do
      @ins = OrderedInstance.create!
      get :preservation, {:id => @ins.pid}
      assigns(:ordered_instance).should eq(@ins)
    end
  end

  describe 'Update Permission' do
    it 'should update permission' do
      @oi = OrderedInstance.new
      @oi.discover_groups_string='dg1','dg2'
      expect(@oi.discover_groups_string).to eql "dg1, dg2"
    end
  end

  after(:all) do
    BasicFile.all.each { |bf| bf.delete }
    TiffFile.all.each { |tf| tf.delete }
    OrderedInstance.all.each { |ins| ins.delete }
  end
end
