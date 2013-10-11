# -*- encoding : utf-8 -*-

# The helper methods for preservation.
# Provides methods for managing the preservation metadata, etc.
module PreservationHelper
  include MqHelper

  # Updates the preservation settings from the controller.
  # @param params The parameters from the controller.
  # @param element The element to have its preservation settings updated.
  def update_preservation_profile_from_controller(params, element)
    if update_preservation_profile(params[:preservation][:preservation_profile], params[:preservation][:preservation_comment], element)
      # If it is the 'perform preservation' button which has been pushed, then it should send a message.
      if(params[:commit] == Constants::PERFORM_PRESERVATION_BUTTON)
        update_preservation_state(Constants::PRESERVATION_STATE_INITIATED, 'The preservation button has been pushed.', element)
        send_message_to_preservation(element.uuid, nil, element.descMetadata.to_xml)
        redirect_to element, notice: "Preservation metadata for the #{element.class} successfully updated and the preservation has begun."
      else
        redirect_to element, notice: "Preservation metadata for the #{element.class} successfully updated"
      end
    else
      render action: 'preservation'
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
  # Updates the preservation profile for a given element (e.g. a file, a representation, a work, etc.)
  # @param profile The name of the profile to update with.
  # @param comment The comment attached to the preservation
  # @param element The element to have its preservation profile changed.
  # @return Whether the update was successfull.
  def update_preservation_profile(profile, comment, element)
    logger.debug "Updating '#{element.to_s}' with profile '#{profile}' and comment '#{comment}'"
    if (profile.blank? || element.preservationMetadata.preservation_profile.first == profile) && (comment.blank? || element.preservationMetadata.preservation_comment.first == comment)
      logger.debug 'Nothing to change for the preservation update'
      return true
    end

    # Do not update, if the preservation profile is not among the valid profiles in the configuration.
    unless PRESERVATION_CONFIG["preservation_profile"].keys.include? profile
      element.errors[:preservation_profile] << "The profile '#{profile}' is not amongst the valid ones: #{PRESERVATION_CONFIG["preservation_profile"].keys}"
      return false
    end

    set_preservation_time(element)
    element.preservationMetadata.preservation_profile = profile
    element.preservationMetadata.preservation_comment = comment
    element.save
  end

  # Updates the preservation state and details for a given element (e.g. a file, a representation, a work, etc.)
  # @param state The new state for the element.
  # @param details The details regarding the state.
  # @param element The element to has its preservation state updated.
  # @return Whether the update was successfull.
  def update_preservation_state(state, details, element)
    logger.debug "Updating '#{element.to_s}' with state '#{state}' and details '#{details}'"
    if (state.blank? || element.preservationMetadata.preservation_state.first == state) && (details.blank? || element.preservationMetadata.preservation_details.first == details)
      logger.debug 'Nothing to change for the preservation update'
      return true
    end

    set_preservation_time(element)
    element.preservationMetadata.preservation_state = state
    element.preservationMetadata.preservation_details = details
    element.save
  end
end
