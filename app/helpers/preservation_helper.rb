# -*- encoding : utf-8 -*-

# The helper methods for preservation.
# Provides methods for managing the preservation metadata, etc.
module PreservationHelper
  include MqHelper # methods: send_message_to_preservation

  # Updates the preservation profile metadata from the controller.
  # If it is the 'perform preservation' button which has been pushed, then it should send a message, and set the state
  # to 'PRESERVATION INITIATED'.
  # @param params The parameters from the controller.
  # @param update_preservation_metadata_uri The uri for updating the preservation state.
  # @param file_uuid The uuid for the content-file. Should be nil, if no content-file.
  # @param content_uri The uri for the retrieving the content-file. Should be nil, if no content-file.
  # @param element The element to have its preservation settings updated.
  def update_preservation_profile_from_controller(params, update_preservation_metadata_uri, file_uuid, content_uri,
      element)
    set_preservation_profile(params[:preservation][:preservation_profile], params[:preservation][:preservation_comment],
                             element)
    if(params[:commit] && params[:commit] == Constants::PERFORM_PRESERVATION_BUTTON)
      set_preservation_metadata({'preservation_state' => Constants::PRESERVATION_STATE_INITIATED.keys.first,
                                 'preservation_details' => 'The preservation button has been pushed.'}, element)
      message = create_message(element.uuid, update_preservation_metadata_uri, file_uuid, content_uri, element)
      send_message_to_preservation(message)
      redirect_to element, notice: "Preservation metadata for the #{element.class} successfully updated and the preservation has begun."
    else
      redirect_to element, notice: "Preservation metadata for the #{element.class} successfully updated"
    end
  end

  # Updates the preservation state metadata from the controller.
  # Expected to receive parameters:
  # params[:preservation][:preservation_state]
  # params[:preservation][:preservation_details]
  # @param params The parameters from the controller.
  # @param element The element to have its preservation settings updated.
  # @return The http response code.
  def update_preservation_metadata_from_controller(params, element)
    if set_preservation_metadata(params[:preservation], element)
      return :ok #200
    else
      return :bad_request #400
    end
  end

  # Updates the preservation date to this exact point in time.
  # The date has to be formatted explicitly to include the milli/micro/nano-seconds.
  # E,g, 2013-10-08T11:02:00.240+02:00
  # @param element The element to have its preservation date updated.
  def set_preservation_modified_time(element)
    element.preservationMetadata.preservation_modify_date = DateTime.now.strftime("%FT%T.%L%:z")
  end

  private
  # Creates a JSON message based in the defined format.
  # @param uuid The UUID for the element to be preserved.
  # @param update_uri The URL for updating the preservation metadata.
  # @param file_uuid The uuid for the content-file. This is only expected from BasicFile.
  # @param content_uri The URL for where the content-file can be downloaded. This is only expected from BasicFile.
  # @param element The element to be preserved.
  # @return The preservation message in JSON format.
  def create_message(uuid, update_uri, file_uuid, content_uri, element)
    message = Hash.new
    message['UUID'] = uuid
    message['Preservation_profile'] = element.preservationMetadata.preservation_profile.first
    unless update_uri.blank?
      message['Update_URI'] = update_uri
    end
    unless file_uuid.blank?
      message['File_UUID'] = file_uuid
    end
    unless content_uri.blank?
      message['Content_URI'] = content_uri
    end

    metadata = Hash.new
    element.datastreams.each do |key, content|
      if Constants::NON_RETRIEVABLE_DATASTREAM_NAMES.include?(key)
        next
      end
      metadata[key] = content.respond_to?(:to_xml) ? content.to_xml : content.content
    end
    message['metadata'] = metadata

    message.to_json
  end

  # Updates the preservation profile for a given element (e.g. a basic_files, a representation, a work, etc.)
  # @param profile The name of the profile to update with.
  # @param comment The comment attached to the preservation
  # @param element The element to have its preservation profile changed.
  def set_preservation_profile(profile, comment, element)
    logger.debug "Updating '#{element.to_s}' with profile '#{profile}' and comment '#{comment}'"
    if (profile.blank? || element.preservationMetadata.preservation_profile.first == profile) && (comment.blank? || element.preservationMetadata.preservation_comment.first == comment)
      logger.debug 'Nothing to change for the preservation update'
      return
    end

    # Do not update, if the preservation profile is not among the valid profiles in the configuration.
    unless PRESERVATION_CONFIG["preservation_profile"].keys.include? profile
      raise ArgumentError, "The profile '#{profile}' is not amongst the valid ones: #{PRESERVATION_CONFIG["preservation_profile"].keys}"
    end

    set_preservation_modified_time(element)
    element.preservationMetadata.preservation_profile = profile
    element.preservationMetadata.preservation_comment = comment
    element.save
  end

  # Updates the preservation state and details for a given element (e.g. a basic_files, a representation, a work, etc.)
  # The preservation state is expected to be among the Constants::PRESERVATION_STATES, a warning will be issued if not.
  # @param metadata The hash with metadata to be updated.
  # @param element The element to has its preservation state updated.
  # @return Whether the update was successful. Or just false, if no metadata is provided.
  def set_preservation_metadata(metadata, element)
    unless metadata && !metadata.empty?
      return false
    end

    logger.debug "Updating '#{element.to_s}' with preservation metadata '#{metadata}'"
    updated = false

    unless (metadata['preservation_state'].blank? || metadata['preservation_state'] == element.preservationMetadata.preservation_state.first)
      updated = true
      unless Constants::PRESERVATION_STATES.keys.include? metadata['preservation_state']
        logger.warn("Undefined preservation state #{metadata['preservation_state']} not among the defined ones:" +
                     "#{Constants::PRESERVATION_STATES.keys.to_s}")
      end
      element.preservationMetadata.preservation_state = metadata['preservation_state']
    end

    unless (metadata['preservation_details'].blank? || metadata['preservation_details'] == element.preservationMetadata.preservation_details.first)
      updated = true
      element.preservationMetadata.preservation_details = metadata['preservation_details']
    end

    unless (metadata['warc_id'].blank? || metadata['warc_id'] == element.preservationMetadata.warc_id.first)
      updated = true
      element.preservationMetadata.warc_id = metadata['warc_id']
    end

    if updated
      set_preservation_modified_time(element)
    end

    element.save
  end
end
