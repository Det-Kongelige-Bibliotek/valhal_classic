# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
class ViewFileController < ApplicationController
  # Show a file by delivering it
  # Used for retrieving files around the BasicFile controller, and thus around the authorization.
  # @return The file which needs to be shown, with the original filename and mime-type.
  def show
    begin
      @basic_file = BasicFile.find(params[:pid])
      send_data @basic_file.content.content, {:filename => @basic_file.original_filename, :type => @basic_file.mime_type}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The file you requested could not be found in Fedora! Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to :root
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :root
    end
  end
end