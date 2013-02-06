# -*- encoding : utf-8 -*-
#Controller for retrieving BasicFile objects from Fedora for display to the front-end
#TODO add exception behaviour if a file can't be found
class ViewFileController < ApplicationController
  def show
    begin
      @basic_file = BasicFile.find(params[:pid])
      send_data @basic_file.content.content, {:filename => @basic_file.original_filename, :type => @basic_file.mime_type}
    rescue
      flash[:error] = 'The file you requested could not be found in Fedora!  Please contact your system administrator'
      redirect_to :back
    end
  end
end
