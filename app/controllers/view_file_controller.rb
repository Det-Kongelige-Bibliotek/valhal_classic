# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
class ViewFileController < ApplicationController
  # Retrieve a given basic_files.
  # Bad client-side arguments, e.g. no basic_files-id, or wrong basic_files-id, then a 400 is returned.
  # If something goes wrong service-side, then a 500 is returned.
  def show
    begin
      @basic_file = BasicFile.find(params[:pid])
      send_data @basic_file.content.content, {:filename => @basic_file.original_filename, :type => @basic_file.mime_type}
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
