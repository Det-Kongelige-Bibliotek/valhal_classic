# -*- encoding : utf-8 -*-
require "spec_helper"

describe BookTeiRepresentationsController do
  describe "routing" do

    it "routes to #index" do
      get("/book_tei_representations").should route_to("book_tei_representations#index")
    end

    it "routes to #new" do
      get("/book_tei_representations/new").should route_to("book_tei_representations#new")
    end

    it "routes to #show" do
      get("/book_tei_representations/1").should route_to("book_tei_representations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/book_tei_representations/1/edit").should route_to("book_tei_representations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/book_tei_representations").should route_to("book_tei_representations#create")
    end

    it "routes to #update" do
      put("/book_tei_representations/1").should route_to("book_tei_representations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/book_tei_representations/1").should route_to("book_tei_representations#destroy", :id => "1")
    end

  end
end
