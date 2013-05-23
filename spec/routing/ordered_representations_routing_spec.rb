# -*- encoding : utf-8 -*-
require "spec_helper"

describe OrderedRepresentationsController do
  describe "routing" do

    it "routes to #show" do
      get("/ordered_representations/1").should route_to("ordered_representations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ordered_representations/1/edit").should route_to("ordered_representations#edit", :id => "1")
    end

    it "routes to #update" do
      put("/ordered_representations/1").should route_to("ordered_representations#update", :id => "1")
    end
  end
end
