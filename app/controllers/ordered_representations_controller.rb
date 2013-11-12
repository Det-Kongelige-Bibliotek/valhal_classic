# -*- encoding : utf-8 -*-
#require 'zip/zip'

class OrderedRepresentationsController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller, update_preservation_metadata_from_controller

  authorize_resource

  def show
    @ordered_representation = OrderedRepresentation.find(params[:id])
  end

  def edit
    @ordered_representation = OrderedRepresentation.find(params[:id])
  end

  def update
    @ordered_representation = OrderedRepresentation.find(params[:id])

    if @ordered_representation.update_attributes(params[:ordered_representation])
      redirect_to @ordered_representation, notice: 'Ordered representation was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # Retrieves the thumbnail of the Tiff-image with the given pid.
  # @param pid The id of the file to extract the thumbnail for.
  # @return The thumbnail of the image, or nil if no file was found.
  def thumbnail_url(pid = nil)
    if pid.nil?
      if params[:pid].blank?
        send_data({}, {:status => 404})
        return
      end
      pid = params[:pid]
    end

    file = TiffFile.find(pid)

    if file.datastreams['thumbnail'].nil?
      send_data({}, {:status => 404})
      return
    end

    send_data(file.thumbnail.content, {:filename => file.thumbnail.label, :type => file.thumbnail.mimeType, :disposition => 'inline'})
  end

  # Method for downloading all the basic_files.
  def download_all
    begin
      @ordered_representation = OrderedRepresentation.find(params[:id])
      file_name = "#{@ordered_representation.representation_name}-#{@ordered_representation.pid}.zip"
      t = Tempfile.new("temp-zip-#{params[:id]}-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        @ordered_representation.files.each do |f|
          #add basic_files to zip basic_files
          z.put_next_entry(f.original_filename)
          z.write f.content.content
        end
      end

      send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => file_name
      t.close
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The basic_files you requested could not be found in Fedora! Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to :back
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :back
    end
  end

  # Updates the preservation profile metadata.
  def update_preservation_profile
    @rep = OrderedRepresentation.find(params[:id])
    begin
      update_preservation_profile_from_controller(params, update_preservation_metadata_ordered_representation_url, nil,
                                                  nil, @rep)
    rescue => error
      @rep.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end


  # Updates the preservation state metadata.
  def update_preservation_metadata
    begin
      @rep = OrderedRepresentation.find(params[:id])
      status = update_preservation_metadata_from_controller(params, @rep)
      render text: status, status: status
    rescue ActiveFedora::ObjectNotFoundError => error
      render text: error, status: :not_found #404
    rescue => error
      logger.warn "Could not update preservation metadata: #{error.inspect}"
      render text: error, status: :internal_server_error #500
    end
  end
end
