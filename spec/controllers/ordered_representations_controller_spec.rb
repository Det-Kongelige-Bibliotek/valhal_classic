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

  describe "GET show" do
    it "assigns the requested ordered_representation as @ordered_representation" do
      ordered_representation = OrderedRepresentation.create! valid_attributes
      get :show, {:id => ordered_representation.to_param}, valid_session
      assigns(:ordered_representation).should eq(ordered_representation)
    end
  end

  describe "GET edit" do
    it "assigns the requested ordered_representation as @ordered_representation" do
      ordered_representation = OrderedRepresentation.create! valid_attributes
      get :edit, {:id => ordered_representation.to_param}, valid_session
      assigns(:ordered_representation).should eq(ordered_representation)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ordered_representation" do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        # Assuming there are no other ordered_representations in the database, this
        # specifies that the OrderedRepresentation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        OrderedRepresentation.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => ordered_representation.to_param, :ordered_representation => { "these" => "params" }}, valid_session
      end

      it "assigns the requested ordered_representation as @ordered_representation" do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        put :update, {:id => ordered_representation.to_param, :ordered_representation => valid_attributes}, valid_session
        assigns(:ordered_representation).should eq(ordered_representation)
      end

      it "redirects to the ordered_representation" do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        put :update, {:id => ordered_representation.to_param, :ordered_representation => valid_attributes}, valid_session
        response.should redirect_to(ordered_representation)
      end
    end

    describe "with invalid params" do
      it "assigns the ordered_representation as @ordered_representation" do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrderedRepresentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => ordered_representation.to_param, :ordered_representation => {  }}, valid_session
        assigns(:ordered_representation).should eq(ordered_representation)
      end

      it "re-renders the 'edit' template" do
        ordered_representation = OrderedRepresentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        OrderedRepresentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => ordered_representation.to_param, :ordered_representation => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end
end
