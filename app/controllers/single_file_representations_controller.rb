# -*- encoding : utf-8 -*-
class SingleFileRepresentationsController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller, update_preservation_state_from_controller

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
      redirect_to @single_file_representation, notice: 'Single basic_files representation was successfully updated.'
    else
      render action: "edit"
    end
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    @rep = SingleFileRepresentation.find(params[:id])
    begin
      update_preservation_profile_from_controller(params, update_preservation_state_single_file_representation_url,
                                                  nil, @rep)
    rescue => error
      @rep.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_state
    @rep = SingleFileRepresentation.find(params[:id])
    update_preservation_state_from_controller(params, @rep)
  end

end
