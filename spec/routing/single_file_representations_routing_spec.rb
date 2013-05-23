# -*- encoding : utf-8 -*-
require "spec_helper"

describe SingleFileRepresentationsController do
  describe "routing" do

    it "routes to #show" do
      get("/single_file_representations/1").should route_to("single_file_representations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/single_file_representations/1/edit").should route_to("single_file_representations#edit", :id => "1")
    end

    it "routes to #update" do
      put("/single_file_representations/1").should route_to("single_file_representations#update", :id => "1")
    end
  end
end
