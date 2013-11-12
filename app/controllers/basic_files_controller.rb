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
      update_preservation_profile_from_controller(params,
                                                  update_preservation_metadata_basic_file_url(@file),
                                                  @file.file_uuid,
                                                  download_basic_file_url(@file),
                                                  @file)
    rescue => error
      @file.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_metadata
    begin
      @file = BasicFile.find(params[:id])
      status = update_preservation_metadata_from_controller(params, @file)
      render text: status, status: status
    rescue ActiveFedora::ObjectNotFoundError => error
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
  # Bad client-side arguments, e.g. no BasicFile-id, or wrong BasicFile-id, then a 400 is returned.
  # If something goes wrong service-side, then a 500 is returned.
  def download
    begin
      @file = BasicFile.find(params[:id])
      send_data @file.content.content, {:filename => @file.original_filename, :type => @file.mime_type}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The basic_files you requested could not be found in Fedora! Please contact your system administrator'
      logger.error obj_not_found.to_s
      render status: 400
    rescue => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      render status: 500
    end
  end
end
