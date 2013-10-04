# -*- encoding : utf-8 -*-

# The helper methods for preservation.
# Provides methods for managing the preservation metadata, etc.
module PreservationHelper
  # Updates the preservation metadata for a given element (e.g. a file, a representation, a work, etc.)
  def update_preservation_metadata(profile, comment, element)
    logger.debug "Updating '#{element.to_s}' with profile '#{profile}' and comment '#{comment}'"
    if (profile.blank? || element.preservationMetadata.preservation_profile == profile) \
    && (comment.blank? || element.preservationMetadata.preservation_comment == comment)
      logger.debug 'Nothing to change for the preservation update'
      return true
    end

    unless PRESERVATION_CONFIG["preservation_profile"].keys.include? profile
      element.errors[:preservation_profile] << "The profile '#{profile}' is not amongst the valid ones: #{PRESERVATION_CONFIG["preservation_profile"].keys}"
      return false
    end

    element.preservationMetadata.preservation_profile = profile
    element.preservationMetadata.preservation_comment = comment
    element.preservationMetadata.preservation_date = DateTime.now
    element.save
  end
end
