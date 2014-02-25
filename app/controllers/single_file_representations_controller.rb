# -*- encoding : utf-8 -*-
class SingleFileRepresentationsController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller

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
    @single_file_representation = SingleFileRepresentation.find(params[:id])
    begin
      notice = update_preservation_profile_from_controller(params, @single_file_representation)
      redirect_to @single_file_representation, notice: notice
    rescue => error
      error_msg = "Could not update preservation profile: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @single_file_representation.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end
end
