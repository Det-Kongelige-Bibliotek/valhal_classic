# -*- encoding : utf-8 -*-
class SingleFileRepresentationsController < ApplicationController
  include PreservationHelper

  load_and_authorize_resource

  def show
    @single_file_representation = SingleFileRepresentation.find(params[:id])
  end

  def edit
    @single_file_representation = SingleFileRepresentation.find(params[:id])
  end

  def update
    @single_file_representation = SingleFileRepresentation.find(params[:id])

    if @single_file_representation.update_attributes(params[:single_file_representation])
      redirect_to @single_file_representation, notice: 'Single file representation was successfully updated.'
    else
      render action: "edit"
    end
  end

  # Updates the preservation settings.
  def update_preservation
    update_preservation_profile_from_controller(params, SingleFileRepresentation.find(params[:id]))
  end
end
