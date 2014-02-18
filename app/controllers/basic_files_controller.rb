# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
class BasicFilesController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller, update_preservation_metadata_from_controller

  # Retrieves the basic file for the show view
  def show
    @file = BasicFile.find(params[:id])
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    @file = BasicFile.find(params[:id])
    begin
      notice = update_preservation_profile_from_controller(params, @file)
      redirect_to @file, notice: notice
    rescue => error
      error_msg = "Could not update preservation profile: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @file.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_metadata
    begin
      @file = BasicFile.find(params[:id])
      status = update_preservation_metadata_for_element(params, @file)
      render text: status, status: status
    rescue ValhalErrors::InvalidStateError => error
      logger.warn "Sending a 403 response to the error: #{error.inspect}"
      render text: error, status: :forbidden #403
    rescue ActiveFedora::ObjectNotFoundError => error
      logger.warn "Sending a 404 response to the error: #{error.inspect}"
      render text: error, status: :not_found #404
    rescue => error
      logger.warn "Could not update preservation metadata: #{error.inspect}"
      render text: error, status: :internal_server_error #500
    end
  end

  # Retrieves the basic file for the preservation view
  def preservation
    @file = BasicFile.find(params[:id])
  end

  # Retrieve the content file for a given BasicFile.
  # If a wrong BasicFile-id, then a 404 is returned.
  # If something goes wrong service-side, then a 500 is returned.
  def download
    begin
      @file = BasicFile.find(params[:id])
      send_data @file.content.content, {:filename => @file.original_filename, :type => @file.mime_type}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The basic_files you requested could not be found in Fedora! Please contact your system administrator'
      logger.error obj_not_found.to_s
      render text: obj_not_found.to_s, status: 404
    rescue => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      render text: standard_error.to_s, status: 500
    end
  end
end
