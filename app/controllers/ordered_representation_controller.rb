# -*- encoding : utf-8 -*-
class OrderedRepresentationController < ApplicationController
  load_and_authorize_resource
  def index
    @ordered_representations = OrderedRepresentation.all
  end

  def show
    @ordered_representation = OrderedRepresentation.find(params[:id])
  end

  def new
    @ordered_representation = OrderedRepresentation.new
  end

  def edit
    @ordered_representation = OrderedRepresentation.find(params[:id])
  end

  def destroy
    @ordered_representation = OrderedRepresentation.find(params[:id])
    @ordered_representation.destroy

    redirect_to single_file_representations_url
  end
end
