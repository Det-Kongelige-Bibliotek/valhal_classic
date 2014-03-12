# -*- encoding : utf-8 -*-

include PreservationHelper

# Provides methods for all elements for sending a message over RabbitMQ
module MqListenerHelper
  # Handles the preservation response messages
  # @param message The message in JSON format.
  def handle_preservation_response(message)
    if message['id'].blank? || message['model'].blank? || message['preservation'].nil?
      logger.warn "Invalid preservation response message: #{message}"
      return false
    end

    element = find_element(message['id'], message['model'])
    logger.debug "Updating preservation metadata for: #{element}"
    update_preservation_metadata_for_element(message, element)
  end

  def handle_digitisation_dod_ebook(message)
    logger.debug "Received following DOD eBook message: #{message}"

    if message['id'].blank? || message['fileUri'].blank? || message['workflowId'].nil?
      logger.warn "Invalid preservation response message: #{message}"
      return false
    end

    create_dod_work(message)
  end

  private
  # Locates a given element based on its model and id.
  # If no model matches the element, then an error is raised.
  # @param id The id of the element to look up.
  # @param model The model of the element to look up.
  # @return The element with the given id and the given model.
  def find_element(id, model)
    case model.downcase
      when 'book'
        return Book.find(id)
      when 'work'
        return Work.find(id)
      when 'basicfile'
        return BasicFile.find(id)
      when 'singlefilerepresentation'
        return SingleFileRepresentation.find(id)
      when 'orderedrepresentation'
        return OrderedRepresentation.find(id)
      else
        raise 'Unknown element type'
    end
  end
end
