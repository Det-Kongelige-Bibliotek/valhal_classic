require 'spec_helper'

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

describe SingleFileRepresentationsController do
  #Login a test user with admin rights
  before(:each) do
    login_admin
  end

  # This should return the minimal set of attributes required to create a valid
  # SingleFileRepresentation. As you add validations to SingleFileRepresentation, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {  }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SingleFileRepresentationsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested single_file_representation as @single_file_representation" do
      single_file_representation = SingleFileRepresentation.create! valid_attributes
      get :show, {:id => single_file_representation.to_param}, valid_session
      assigns(:single_file_representation).should eq(single_file_representation)
    end
  end

  describe "GET edit" do
    it "assigns the requested single_file_representation as @single_file_representation" do
      single_file_representation = SingleFileRepresentation.create! valid_attributes
      get :edit, {:id => single_file_representation.to_param}, valid_session
      assigns(:single_file_representation).should eq(single_file_representation)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested single_file_representation" do
        single_file_representation = SingleFileRepresentation.create! valid_attributes
        # Assuming there are no other single_file_representations in the database, this
        # specifies that the SingleFileRepresentation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        SingleFileRepresentation.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => single_file_representation.to_param, :single_file_representation => { "these" => "params" }}, valid_session
      end

      it "assigns the requested single_file_representation as @single_file_representation" do
        single_file_representation = SingleFileRepresentation.create! valid_attributes
        put :update, {:id => single_file_representation.to_param, :single_file_representation => valid_attributes}, valid_session
        assigns(:single_file_representation).should eq(single_file_representation)
      end

      it "redirects to the single_file_representation" do
        single_file_representation = SingleFileRepresentation.create! valid_attributes
        put :update, {:id => single_file_representation.to_param, :single_file_representation => valid_attributes}, valid_session
        response.should redirect_to(single_file_representation)
      end
    end

    describe "with invalid params" do
      it "assigns the single_file_representation as @single_file_representation" do
        single_file_representation = SingleFileRepresentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SingleFileRepresentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => single_file_representation.to_param, :single_file_representation => {  }}, valid_session
        assigns(:single_file_representation).should eq(single_file_representation)
      end

      it "re-renders the 'edit' template" do
        single_file_representation = SingleFileRepresentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        SingleFileRepresentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => single_file_representation.to_param, :single_file_representation => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end


  describe 'Update preservation profile metadata' do
    before(:each) do
      @rep = SingleFileRepresentation.create!
    end
    it 'should have a default preservation settings' do
      rep = SingleFileRepresentation.find(@rep.pid)
      rep.preservation_profile.should_not be_blank
      rep.preservation_state.should_not be_blank
      rep.preservation_details.should_not be_blank
      rep.preservation_modify_date.should_not be_blank
      rep.preservation_comment.should be_blank
    end

    it 'should be updated and redirect to the single basic_files representation' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      rep = SingleFileRepresentation.find(@rep.pid)
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

      rep = SingleFileRepresentation.find(@rep.pid)
      rep.preservation_state.should_not be_blank
      rep.preservation_details.should_not be_blank
      rep.preservation_modify_date.should_not be_blank
      rep.preservation_profile.should_not == profile
      rep.preservation_comment.should_not == comment
    end

    it 'should update the preservation date' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      rep = SingleFileRepresentation.find(@rep.pid)
      d = rep.preservation_modify_date

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      rep = SingleFileRepresentation.find(@rep.pid)
      rep.preservation_modify_date.should_not == d
    end

    it 'should not update the preservation date, when the same profile and comment is given.' do
      profile = PRESERVATION_CONFIG["preservation_profile"].keys.first
      comment = "This is the preservation comment"
      @rep.preservation_profile = profile
      @rep.preservation_comment = comment
      @rep.save

      rep = SingleFileRepresentation.find(@rep.pid)
      d = rep.preservation_modify_date

      put :update_preservation_profile, {:id => @rep.pid, :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      rep = SingleFileRepresentation.find(@rep.pid)
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

      put :update_preservation_profile, {:id => @rep.pid, :commit => "Perform preservation", :preservation => {:preservation_profile => profile, :preservation_comment => comment }}
      response.should redirect_to(@rep)

      q.subscribe do |delivery_info, metadata, payload|
        payload.should include @rep.pid
      end

      rep = SingleFileRepresentation.find(@rep.pid)
      rep.preservation_state.should == 'Preservation initiated'
      conn.close
    end
  end
end
