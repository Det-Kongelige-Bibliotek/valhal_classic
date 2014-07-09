# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderedInstancesController do
  describe "routing" do

    it "routes to #show" do
      get("/ordered_instances/1").should route_to("ordered_instances#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ordered_instances/1/edit").should route_to("ordered_instances#edit", :id => "1")
    end

    it "routes to #update" do
      put("/ordered_instances/1").should route_to("ordered_instances#update", :id => "1")
    end
  end
end
