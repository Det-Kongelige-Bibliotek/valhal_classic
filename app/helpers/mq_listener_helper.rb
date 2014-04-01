# -*- encoding : utf-8 -*-

include PreservationHelper
include DisseminationService

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

  #Handles messages about digitised eBooks for the DOD workflow, these messages contain information about the identity
  # of the book in Aleph and where the actual file containing the eBook is stored in KB's digital infrastructure.  If
  # anything is invalid in the message then we just log a warning message as we don't want to interrupt the normal
  # operation of Valhal by raising an error.
  def handle_digitisation_dod_ebook(message)
    logger.debug "Received following DOD eBook message: #{message}"

    if message['id'].blank? || message['fileUri'].blank? || message['workflowId'].nil?
      logger.warn "Invalid DOD eBook input message: #{message}"
    end

    work = create_dod_work(message)
    logger.debug "Work created"
    disseminate(work, message, DisseminationService::DISSEMINATION_TYPE_BIFROST_BOOKS)
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
      when 'person'
        return Person.find(id)
      else
        raise 'Unknown element type'
    end
  end
end
