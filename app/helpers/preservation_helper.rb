# -*- encoding : utf-8 -*-

# The helper methods for preservation.
# Provides methods for managing the preservation metadata, etc.
module PreservationHelper
  # Updates the preservation profile for a given element (e.g. a file, a representation, a work, etc.)
  # @param profile The name of the profile to update with.
  # @param comment The comment attached to the preservation
  # @param element The element to have its preservation profile changed.
  def update_preservation_profile(profile, comment, element)
    logger.debug "Updating '#{element.to_s}' with profile '#{profile}' and comment '#{comment}'"
    if (profile.blank? || element.preservationMetadata.preservation_profile.first == profile) && (comment.blank? || element.preservationMetadata.preservation_comment.first == comment)
      logger.debug 'Nothing to change for the preservation update'
      return true
    end

    # Do not update, if the preservation profile is not amongst the valid profiles in the configuration.
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

  # Updates the preservation date to this exact point in time.
  # The date has to be formatted explicitly to include the milli/micro/nano-seconds.
  # @param element The element to have its preservation date updated.
  def set_preservation_time(element)
    element.preservationMetadata.preservation_modify_date = DateTime.now.strftime("%FT%T.%L%:z")
  end
end
