# -*- encoding : utf-8 -*-
class SingleFileInstancesController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller

  authorize_resource

  def show
    @single_file_instance = SingleFileInstance.find(params[:id])
  end

  def edit
    @single_file_instance = SingleFileInstance.find(params[:id])
  end

  def preservation
    @single_file_instance = SingleFileInstance.find(params[:id])
  end

  def update
    @single_file_instance = SingleFileInstance.find(params[:id])

    if @single_file_instance.update_attributes(params[:single_file_instance])
      redirect_to @single_file_instance, notice: 'Single basic_files representation was successfully updated.'
    else
      render action: "edit"
    end
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    @single_file_instance = SingleFileInstance.find(params[:id])
    begin
      notice = update_preservation_profile_from_controller(params, @single_file_instance)
      redirect_to @single_file_instance, notice: notice
    rescue => error
      error_msg = "Could not update preservation profile: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @single_file_instance.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end
end
