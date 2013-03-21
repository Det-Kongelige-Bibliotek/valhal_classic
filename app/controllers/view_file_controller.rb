# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
#TODO add exception behaviour if a file can't be found
class ViewFileController < ApplicationController
  def show
    begin
      @basic_file = BasicFile.find(params[:pid])
      send_data @basic_file.content.content, {:filename => @basic_file.original_filename, :type => @basic_file.mime_type}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The file you requested could not be found in Fedora!  Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to :back
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred.  Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :back
    end
  end

  def show_structmap
    begin
      @struct_map = StructMap.find(params[:pid])
      filename = "structmap_#{params[:pid]}.xml"
      send_data @struct_map.techMetadata.content, {:filename => filename, :type => 'text/xml'}
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The file you requested could not be found in Fedora!  Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to :back
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred.  Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :back
    end
  end
end
