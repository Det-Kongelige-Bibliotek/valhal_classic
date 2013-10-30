# -*- encoding : utf-8 -*-
require 'spec_helper'
include PeopleHelper

describe PeopleController do
  before(:each) do
    Person.all.each { |p| p.delete }
  end
  #Login a test user with admin rights
  before(:each) do
    login_admin
  end

  # This should return the minimal set of attributes required to create a valid
  # Person. As you add validations to Person, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :firstname => 'firstname', :lastname => 'lastname', :date_of_birth => Time.now.nsec.to_s }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PeopleController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe 'GET index' do
    it 'assigns all people as @people' do
      person = Person.create! valid_attributes
      get :index, {}, valid_session
      assigns(:people).should eq([person])
    end
  end

  describe 'GET show' do
    it 'assigns the requested person as @person' do
      person = Person.create! valid_attributes
      get :show, {:id => person.to_param}, valid_session
      assigns(:person).should eq(person)
    end
  end

  describe 'GET new' do
    it 'assigns a new person as @person' do
      get :new, {}, valid_session
      assigns(:person).should be_a_new(Person)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested person as @person' do
      person = Person.create! valid_attributes
      get :edit, {:id => person.to_param}, valid_session
      assigns(:person).should eq(person)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Person' do
        expect {
          post :create, {:person => valid_attributes}, valid_session
        }.to change(Person, :count).by(1)
      end

      it 'assigns a newly created person as @person' do
        post :create, {:person => valid_attributes}, valid_session
        assigns(:person).should be_a(Person)
        assigns(:person).should be_persisted
      end

      it 'redirects to the created person' do
        post :create, {:person => valid_attributes}, valid_session
        response.should redirect_to(Person.all.last)
      end

      it 'should be able to create a portrait' do
        post :create, { :person => valid_attributes, :portrait_representation_metadata => {}, :portrait_metadata => {:title => 'Test portrait' + Time.now.nsec.to_s},
            :portrait => { :portrait_file => ActionDispatch::Http::UploadedFile.new(filename: 'test.tiff', type: 'image/png', tempfile: File.new("#{Rails.root}/spec/fixtures/rails.png"))}}

        person = Person.all.last
        response.should redirect_to(person)
        person.has_portrait?.should be_true
        person.concerning_works.length.should == 1
      end
      it 'should be able to create a portrait' do
        post :create, { :person => valid_attributes, :tei_representation_metadata => {}, :person_description_metadata => {:title => 'Test description' + Time.now.nsec.to_s}, :tei_metadata => {},
                        :tei => { :tei_file => ActionDispatch::Http::UploadedFile.new(filename: 'test.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarebo_mets_structmap_sample.xml"))}}

        person = Person.all.last
        response.should redirect_to(person)
        person.has_portrait?.should be_false
        person.concerning_works.length.should == 1
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved person as @person' do
        # Trigger the behavior that occurs when invalid params are submitted
        Person.any_instance.stub(:save).and_return(false)
        post :create, {:person => {firstname: 'firstname', lastname: 'lastname'}}, valid_session
        assigns(:person).should be_a_new(Person)
      end

      it 're-renders the \'new\' template' do
        # Trigger the behavior that occurs when invalid params are submitted
        Person.any_instance.stub(:save).and_return(false)
        post :create, {:person => { }}, valid_session
        response.should render_template('new')
      end

      it 'should not allow empty arguments' do
        post :create, {}
        response.should render_template('new')
      end

      it 'should not allow a non-image basic_files as portrait' do
        post :create, { :person => valid_attributes, :portrait => { :portrait_file => ActionDispatch::Http::UploadedFile.new(filename: 'test.xml', type: 'text/xml', tempfile: File.new("#{Rails.root}/spec/fixtures/aarebo_mets_structmap_sample.xml"))}}
        response.should render_template('new')
      end
      it 'should not allow a non-xml basic_files as description' do
        post :create, { :person => valid_attributes, :tei => { :tei_file => ActionDispatch::Http::UploadedFile.new(filename: 'test.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))}}
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested person' do
        person = Person.create! valid_attributes
        # Assuming there are no other people in the database, this
        # specifies that the Person created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Person.any_instance.should_receive(:update_attributes).with({ 'these' => 'params' })
        put :update, {:id => person.to_param, :person => { 'these' => 'params' }}, valid_session
      end

      it 'assigns the requested person as @person' do
        person = Person.create! valid_attributes
        put :update, {:id => person.to_param, :person => valid_attributes}, valid_session
        assigns(:person).should eq(person)
      end

      it 'redirects to the person' do
        person = Person.create! valid_attributes
        put :update, {:id => person.to_param, :person => valid_attributes}, valid_session
        response.should redirect_to(person)
      end
    end

    describe 'with invalid params' do
      it 'assigns the person as @person' do
        person = Person.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Person.any_instance.stub(:save).and_return(false)
        put :update, {:id => person.to_param, :person => {  }}, valid_session
        assigns(:person).should eq(person)
      end

      it 're-renders the \'edit\' template' do
        person = Person.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Person.any_instance.stub(:save).and_return(false)
        put :update, {:id => person.to_param, :person => {  }}, valid_session
        response.should render_template('edit')
      end

      it 'should not allow a non-xml basic_files as description' do
        person = Person.create! valid_attributes
        post :update, { :id => person.to_param, :tei => { :tei_file => ActionDispatch::Http::UploadedFile.new(filename: 'test.tiff', type: 'image/tiff', tempfile: File.new("#{Rails.root}/spec/fixtures/arre1fm001.tif"))}}
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested person' do
      person = Person.create! valid_attributes
      expect {
        delete :destroy, {:id => person.to_param}, valid_session
      }.to change(Person, :count).by(-1)
    end

    it 'redirects to the people list' do
      person = Person.create! valid_attributes
      delete :destroy, {:id => person.to_param}, valid_session
      response.should redirect_to(people_url)
    end
  end
  
  describe 'GET show_image' do
    before(:each) do
      @person = Person.create! valid_attributes
      @tiff_file = ActionDispatch::Http::UploadedFile.new(filename: 'aoa._foto.jpg', type: 'image/jpg', tempfile: File.new("#{Rails.root}/spec/fixtures/aoa._foto.jpg"))
    end

    it 'should be able to deliver the URL for the image when the portrait is defined' do
      add_portrait(@tiff_file, {}, {:title => 'Portrait of ' + Time.now.nsec.to_s}, @person).should be_true

      get :show_image, {:id => @person.pid}
      response.response_code.should == 200
    end

    it 'should not be able, when no portrait exists' do
      get :show_image, {:id => @person.pid}
      response.response_code.should == 404
    end
  end


  describe 'Update preservation profile metadata' do
    before(:each) do
      @person = Person.create! valid_attributes
    end
    it 'should have a default preservation settings' do
      person = Person.find(@person.pid)
      person.preservation_profile.should_not be_blank
      person.preservation_state.should_not be_blank
      person.preservation_details.should_not be_blank
      person.preservation_modify_date.should_not be_blank
      person.preservation_comment.should be_blank
    end

    it 'should be updated and redirect to the person' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @person.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@person)

      person = Person.find(@person.pid)
      person.preservation_state.should_not be_blank
      person.preservation_details.should_not be_blank
      person.preservation_modify_date.should_not be_blank
      person.preservation_profile.should == profile
      person.preservation_comment.should == comment
    end

    it 'should not update or redirect, when the profile is wrong.' do
      profile = "wrong profile #{Time.now.to_s}"
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @person.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should_not redirect_to(@person)

      person = Person.find(@person.pid)
      person.preservation_state.should_not be_blank
      person.preservation_details.should_not be_blank
      person.preservation_modify_date.should_not be_blank
      person.preservation_profile.should_not == profile
      person.preservation_comment.should_not == comment
    end

    it 'should update the preservation date' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      person = Person.find(@person.pid)
      d = person.preservation_modify_date

      put :update_preservation_profile, {:id => @person.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@person)

      person = Person.find(@person.pid)
      person.preservation_modify_date.should_not == d
    end

    it 'should not update the preservation date, when the same profile and comment is given.' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      @person.preservation_profile = profile
      @person.preservation_comment = comment
      @person.save

      person = Person.find(@person.pid)
      d = person.preservation_modify_date

      put :update_preservation_profile, {:id => @person.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@person)

      person = Person.find(@person.pid)
      person.preservation_modify_date.should == d
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

      put :update_preservation_profile, {:id => @person.pid, :commit => "Perform preservation", :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@person)

      q.subscribe do |delivery_info, metadata, payload|
        payload.should include @person.pid
      end

      person = Person.find(@person.pid)
      person.preservation_state.should == Constants::PRESERVATION_STATE_INITIATED.keys.first
      conn.close
    end
  end

  describe 'Update preservation state metadata' do
    before(:each) do
      @person = Person.create! valid_attributes
    end
    it 'should be updated and redirect to the person' do
      state = "TheNewState-#{Time.now.to_s}"
      details = "Any details will suffice."

      put :update_preservation_state, {:id => @person.pid, :preservation => {:preservation_state => state, :preservation_details => details }}
      response.should redirect_to(@person)

      per = Person.find(@person.pid)
      per.preservation_state.should == state
      per.preservation_details.should == details
      per.preservation_modify_date.should_not be_blank
      per.preservation_profile.should_not be_blank
    end

    it 'should change the values when updating' do
      old_state = "TheOldState-#{Time.now.to_s}"
      new_state = "tHEnEWsTATE-#{Time.now.to_s}"
      old_details = "Any details will suffice."
      new_details = "No details are accepted!"

      per = Person.find(@person.pid)
      per.preservation_state = old_state
      per.preservation_details = old_details
      per.save!

      d = per.preservation_modify_date

      per = Person.find(@person.pid)
      per.preservation_state.should == old_state
      per.preservation_state.should_not == new_state
      per.preservation_details.should == old_details
      per.preservation_details.should_not == new_details

      put :update_preservation_state, {:id => @person.pid, :preservation => {:preservation_state => new_state, :preservation_details => new_details }}
      response.should redirect_to(@person)

      per = Person.find(@person.pid)
      per.preservation_state.should == new_state
      per.preservation_state.should_not == old_state
      per.preservation_details.should == new_details
      per.preservation_details.should_not == old_details
      per.preservation_modify_date.should_not == d
    end

    it 'should not update when same values' do
      state = "TheState-#{Time.now.to_s}"
      details = "TheDetails-#{Time.now.to_s}"

      per = Person.find(@person.pid)
      per.preservation_state = state
      per.preservation_details = details
      per.save!

      d = per.preservation_modify_date

      put :update_preservation_state, {:id => @person.pid, :preservation => {:preservation_state => state, :preservation_details => details }}
      response.should redirect_to(@person)

      per = Person.find(@person.pid)
      per.preservation_state.should == state
      per.preservation_details.should == details
      per.preservation_modify_date.should == d
    end
  end

  after(:all) do
    Person.all.each {|p| p.delete}
  end
end
