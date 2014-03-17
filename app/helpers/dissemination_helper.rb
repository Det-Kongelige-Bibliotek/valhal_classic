# -*- encoding : utf-8 -*-

# The helper methods for dissemination.
# Currently only for dissemination through BifrostBøger.
module DisseminationHelper
  include MqHelper # methods: send_message_to_bifrost_books

  # constant for BifrostBooks type.
  DISSEMINATION_TYPE_BIFROST_BOOKS = 'BifrostBøger'

  # Disseminate a DOD-work
  # @param work The work with the DOD-book to disseminate
  # @param message The message containing the URL for the PDF.
  def disseminate(work, digitization_message, type)
    message = create_message(work, digitization_message, type)
    send_message_to_bifrost_books(message)
  end

  private
  # Creates a message depending on the dissemination type
  # Currently only BifrostBøger supported.
  def create_message(work, digitization_message, type)
    case type
      when DISSEMINATION_TYPE_BIFROST_BOOKS
        create_message_for_dod_book(work, digitization_message)
      else
        raise "Cannot disseminate type #{type}"
    end
  end

  # Format:
  # UUID - The unique identifier for the work
  # Dissemination_type - The type of dissemination
  # Type - The type of work
  # Files - A map between order and URL for the pdf files.
  # MODS - The descMetadata datastream in XML.
  #
  # @param work The work to create the DOD object for.
  # @param digitization_message The message from digitization with the URL.
  # @return The message in JSON format.
  def create_message_for_dod_book(work, digitization_message)
    message = Hash.new
    message['UUID'] = work.uuid
    message['Dissemination_type'] = 'BifrostBøger'
    message['Type'] = element.pid
    # TODO this is a hack, since we currently cannot handle more than url.
    message['Files'] = {'1' => digitization_message['fileUri']}
    message['MODS'] = work.descMetadata.content.to_xml

    message.to_json
  end
end
