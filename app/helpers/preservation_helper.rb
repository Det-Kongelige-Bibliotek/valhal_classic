# -*- encoding : utf-8 -*-

# The helper methods for preservation.
# Provides methods for managing the preservation metadata, etc.
module PreservationHelper
  include MqHelper # methods: send_message_to_preservation

  # Updates the preservation profile metadata from the controller.
  # If it is the 'perform preservation' button which has been pushed, then it should send a message, and set the state
  # to 'PRESERVATION INITIATED'.
  # @param params The parameters from the controller.
  # @param element The element to have its preservation settings updated.
  def update_preservation_profile_from_controller(params, element)
    logger.info "Update preservation profile #{element}"
    inherit_preservation(params, element)
    set_preservation_profile(params[:preservation][:preservation_profile], params[:preservation][:preservation_comment],
                             element)
    if(params[:commit] && params[:commit] == Constants::PERFORM_PRESERVATION_BUTTON)
      initiate_preservation(element)
      return "Preservation profile for the #{element.class} successfully updated and the preservation has begun."
    else
      return "Preservation profile for the #{element.class} successfully updated"
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
    ensure_preservation_state_allows_update_from_controller(element.preservation_state)

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
  # Initiates the preservation. If the profile
  # @param element The element to perform the preservation upon.
  def initiate_preservation(element)
    profile = PRESERVATION_CONFIG['preservation_profile'][element.preservation_profile]

    if profile['yggdrasil'].blank? or profile['yggdrasil'] == 'false'
      set_preservation_metadata({'preservation_state' => Constants::PRESERVATION_STATE_NOT_LONGTERM.keys.first,
                                 'preservation_details' => 'Not longterm preservation.'}, element)
    else
      set_preservation_metadata({'preservation_state' => Constants::PRESERVATION_STATE_INITIATED.keys.first,
                                 'preservation_details' => 'The preservation button has been pushed.'}, element)
      message = create_message(element)
      send_message_to_preservation(message)
    end
  end

  # Creates a JSON message based in the defined format.
  # @param element The element to be preserved.
  # @return The preservation message in JSON format.
  def create_message(element)
    message = Hash.new
    message['UUID'] = element.uuid
    message['Preservation_profile'] = element.preservationMetadata.preservation_profile.first
    message['Update_URI'] = url_for(controller: element.class.name.underscore.pluralize, action: 'update_preservation_metadata', id: element.pid)
    #message['Update_URI'] = element.update_preservation_metadata_uri

    if element.kind_of?(BasicFile)
      message['File_UUID'] = element.file_uuid
      message['Content_URI'] = download_basic_file_url(element)
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
    unless PRESERVATION_CONFIG['preservation_profile'].keys.include? profile
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

  # Validates whether the preservation_state allows updating through the controller.
  # Checks whether the preservation state is set to not stated.
  # @param state The state to validate.
  def ensure_preservation_state_allows_update_from_controller(state)
    if !state.blank? && state == Constants::PRESERVATION_STATE_NOT_STARTED.keys.first
      raise ValhalErrors::InvalidStateError, 'Cannot update preservation state, when preservation has not yet started.'
    end
  end

  # Check whether it should be inherited, and also perform the inheritance.
  # @param params The parameter from the controller. Contains the parameter for whether the preservation
  # should be inherit.
  # @param element The element to have stuff inherited.
  def inherit_preservation(params, element)
    if(element.preservation_inheritance? && params['preservation']['preservation_inheritance'] == '1')
      element.preservation_inheritable_objects.each do |pib|
        update_preservation_profile_from_controller(params, pib)
      end
    end
  end
end
