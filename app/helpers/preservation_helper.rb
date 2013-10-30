# -*- encoding : utf-8 -*-

# The helper methods for preservation.
# Provides methods for managing the preservation metadata, etc.
module PreservationHelper
  include MqHelper # methods: send_message_to_preservation

  # Updates the preservation profile metadata from the controller.
  # @param params The parameters from the controller.
  # @param update_preservation_state_uri The uri for the updating the preservation state.
  # @param content_uri The uri for the retrieving the content-file.
  # @param element The element to have its preservation settings updated.
  def update_preservation_profile_from_controller(params, update_preservation_state_uri, content_uri, element)
    set_preservation_profile(params[:preservation][:preservation_profile], params[:preservation][:preservation_comment], element)
    # If it is the 'perform preservation' button which has been pushed, then it should send a message.
    if(params[:commit] == Constants::PERFORM_PRESERVATION_BUTTON)
      set_preservation_state(Constants::PRESERVATION_STATE_INITIATED.keys.first, 'The preservation button has been pushed.', element)
      message = create_message(element.uuid, update_preservation_state_uri, content_uri, element)
      logger.info "Sending preservation message: #{message.to_s}"
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
  def update_preservation_state_from_controller(params, element)
    if set_preservation_state(params[:preservation][:preservation_state], params[:preservation][:preservation_details], element)
      redirect_to element, notice: "Preservation metadata for the #{element.class} successfully updated"
    else
      render status: 400
    end
  end

  # Updates the preservation date to this exact point in time.
  # The date has to be formatted explicitly to include the milli/micro/nano-seconds.
  # E,g, 2013-10-08T11:02:00.240+02:00
  # @param element The element to have its preservation date updated.
  def set_preservation_time(element)
    element.preservationMetadata.preservation_modify_date = DateTime.now.strftime("%FT%T.%L%:z")
  end

  private
  def create_message(uuid, update_uri, content_uri, element)
    message = "UUID: #{uuid}\n"
    unless update_uri.blank?
      message += "Update_URI: #{update_uri}\n"
    end
    unless content_uri.blank?
      message += "Content_URI: #{content_uri}\n"
    end

    element.datastreams.each do |key, content|
      if Constants::NON_RETRIEVABLE_DATASTREAM_NAMES.include?(key)
        next
      end
      message += "#{key}: #{content.respond_to?(:to_xml) ? content.to_xml : content.content}\n"
    end

    message
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

    set_preservation_time(element)
    element.preservationMetadata.preservation_profile = profile
    element.preservationMetadata.preservation_comment = comment
    element.save
  end

  # Updates the preservation state and details for a given element (e.g. a basic_files, a representation, a work, etc.)
  # @param state The new state for the element. Expected to match the Constants::PRESERVATION_STATES
  # @param details The details regarding the state.
  # @param element The element to has its preservation state updated.
  # @return Whether the update was successfull.
  def set_preservation_state(state, details, element)
    logger.debug "Updating '#{element.to_s}' with state '#{state}' and details '#{details}'"
    if (state.blank? || element.preservationMetadata.preservation_state.first == state) && (details.blank? || element.preservationMetadata.preservation_details.first == details)
      logger.debug 'Nothing to change for the preservation update'
      return true
    end

    unless Constants::PRESERVATION_STATES.keys.include? state
      logger.warn("Undefined preservation state #{state} not among the defined ones:
                   #{Constants::PRESERVATION_STATES.keys.to_s}")
    end

    set_preservation_time(element)
    element.preservationMetadata.preservation_state = state
    element.preservationMetadata.preservation_details = details
    element.save
  end
end
