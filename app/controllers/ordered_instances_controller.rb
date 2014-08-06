# -*- encoding : utf-8 -*-
#require 'zip/zip'

class OrderedInstancesController < ApplicationController
  include PreservationHelper # methods: update_preservation_profile_from_controller
  include InstanceHelper

  authorize_resource

  def show
    @ordered_instance = OrderedInstance.find(params[:id])
  end

  def edit
    @ordered_instance = OrderedInstance.find(params[:id])
  end

  def preservation
    @ordered_instance = OrderedInstance.find(params[:id])
  end

  def update
    @ordered_instance = OrderedInstance.find(params[:id])

    add_agents(params[:instance_agents], @ordered_instance) unless params[:instance_agents].blank?

    if @ordered_instance.update_attributes(params[:ordered_instance])
      redirect_to @ordered_instance, notice: 'Ordered instance was successfully updated.'
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
      @ordered_instance = OrderedInstance.find(params[:id])
      file_name = "#{@ordered_instance.instance_name}-#{@ordered_instance.pid}.zip"
      t = Tempfile.new("temp-zip-#{params[:id]}-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        @ordered_instance.files.each do |f|
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
    @ordered_instance = OrderedInstance.find(params[:id])
    begin
      notice = update_preservation_profile_from_controller(params, @ordered_instance)
      redirect_to @ordered_instance, notice: notice
    rescue => error
      error_msg = "Could not update preservation profile: #{error.inspect}"
      error.backtrace.each do |l|
        error_msg += "\n#{l}"
      end
      logger.error error_msg
      @ordered_instance.errors[:preservation] << error.inspect.to_s
      render action: 'preservation'
    end
  end

  def show_mods
    @ordered_instance = OrderedInstance.find(params[:id])
    begin
      mods = TransformationService.transform_to_mods(@ordered_instance)
      errors = TransformationService.validate_mods(mods)
      if errors.empty?
        logger.info "Sending valid MODS record for Work: {ID: #{@ordered_instance.id}, UUID: #{@ordered_instance.uuid}}"
        send_data mods, {:filename => "#{@ordered_instance.uuid}-mods.xml", :type => 'text/xml'}
      else
        logger.warn "Issue when transforming to MODS for Work: {ID: #{@ordered_instance.id}, UUID: #{@ordered_instance.uuid}}:\n #{errors}"
        redirect_to @ordered_instance, notice: "Could not transform into valid MODS (version 3.5): #{errors}"
      end
    rescue ActiveFedora::ObjectNotFoundError => obj_not_found
      flash[:error] = 'The file you requested could not be found in Fedora! Please contact your system administrator'
      logger.error obj_not_found.to_s
      redirect_to @ordered_instance
    rescue StandardError => standard_error
      flash[:error] = 'An error has occurred. Please contact your system administrator'
      logger.error standard_error.to_s
      redirect_to :root
    end
  end
end
