# -*- encoding : utf-8 -*-
class SingleFileInstancesController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller
  include InstanceHelper

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

    add_agents(params[:instance_agents], @single_file_instance)

    if @single_file_instance.update_attributes(params[:single_file_instance])
      redirect_to @single_file_instance, notice: 'Single file instance was successfully updated.'
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

  def show_mods
    @single_file_instance = SingleFileInstance.find(params[:id])
    begin
      send_data TransformationService.transform_to_mods(@single_file_instance), {:filename => "#{@single_file_instance.uuid}-mods.xml", :type => 'text/xml'}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The file you requested could not be found in Valhal! Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to @single_file_instance
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :root
    end
  end
end
