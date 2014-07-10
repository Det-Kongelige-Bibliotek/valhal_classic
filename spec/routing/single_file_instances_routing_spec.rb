# -*- encoding : utf-8 -*-
require "spec_helper"

describe SingleFileInstancesController do
  describe "routing" do

    it "routes to #show" do
      get("/single_file_instances/1").should route_to("single_file_instances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/single_file_instances/1/edit").should route_to("single_file_instances#edit", :id => "1")
    end

    it "routes to #update" do
      put("/single_file_instances/1").should route_to("single_file_instances#update", :id => "1")
    end
  end
end
