require "spec_helper"

describe SingleFileRepresentationsController do
  describe "routing" do

    it "routes to #index" do
      get("/single_file_representations").should route_to("single_file_representations#index")
    end

    it "routes to #new" do
      get("/single_file_representations/new").should route_to("single_file_representations#new")
    end

    it "routes to #show" do
      get("/single_file_representations/1").should route_to("single_file_representations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/single_file_representations/1/edit").should route_to("single_file_representations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/single_file_representations").should route_to("single_file_representations#create")
    end

    it "routes to #update" do
      put("/single_file_representations/1").should route_to("single_file_representations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/single_file_representations/1").should route_to("single_file_representations#destroy", :id => "1")
    end

  end
end
