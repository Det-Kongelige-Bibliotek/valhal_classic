# -*- encoding : utf-8 -*-
class SingleFileRepresentationsController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller, update_preservation_metadata_from_controller

  authorize_resource

  def show
    @single_file_representation = SingleFileRepresentation.find(params[:id])
  end

  def edit
    @single_file_representation = SingleFileRepresentation.find(params[:id])
  end

  def preservation
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
      update_preservation_profile_from_controller(params, update_preservation_metadata_single_file_representation_url,
                                                  nil, nil, @rep)
    rescue => error
      @rep.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_metadata
    begin
      @rep = SingleFileRepresentation.find(params[:id])
      status = update_preservation_metadata_from_controller(params, @rep)
      render text: status, status: status
    rescue ActiveFedora::ObjectNotFoundError => error
      render text: error, status: :not_found #404
    rescue => error
      logger.warn "Could not update preservation metadata: #{error.inspect}"
      render text: error, status: :internal_server_error #500
    end
  end
end
