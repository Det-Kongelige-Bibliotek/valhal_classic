# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
class BasicFilesController < ApplicationController
  include PreservationHelper

  def show
    @file = BasicFile.find(params[:id])
  end

  # Updates the preservation settings.
  def update_preservation_profile
    @file = BasicFile.find(params[:id])
    begin
      update_preservation_profile_from_controller(params,
                                                  update_preservation_state_single_file_representation_url(@file),
                                                  download_basic_file_url(@file),
                                                  @file)
    rescue => error
      @file.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  # Updates the preservation state metadata.
  def update_preservation_state
    @file = BasicFile.find(params[:id])
    update_preservation_state_from_controller(params, @file)
  end

  def preservation
    @file = BasicFile.find(params[:id])
  end

  # Retrieve a given basic_files.
  # Bad client-side arguments, e.g. no basic_files-id, or wrong basic_files-id, then a 400 is returned.
  # If something goes wrong service-side, then a 500 is returned.
  def download
    begin
      @file = BasicFile.find(params[:id])
      send_data @file.content.content, {:filename => @file.original_filename, :type => @file.mime_type}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The basic_files you requested could not be found in Fedora!  Please contact your system administrator'
      logger.error obj_not_found.to_s
      render status: 400
    rescue => standard_error
      flash[:error] = 'An error has occurred.  Please contact your system administrator'
      logger.error standard_error.to_s
      render status: 500
    end
  end
end
