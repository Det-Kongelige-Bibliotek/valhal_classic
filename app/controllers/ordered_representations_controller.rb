# -*- encoding : utf-8 -*-
class OrderedRepresentationsController < ApplicationController
  load_and_authorize_resource
  def index
    @ordered_representations = OrderedRepresentation.all
  end

  def show
    @ordered_representation = OrderedRepresentation.find(params[:id])
  end

  def edit
    @ordered_representation = OrderedRepresentation.find(params[:id])
  end

  def update
    @ordered_representation = OrderedRepresentation.find(params[:id])

    if @ordered_representation.update_attributes(params[:ordered_representation])
      redirect_to @ordered_representation, notice: 'Ordered representation was successfully updated.'
    else
      render action: "edit"
    end
  end
end
