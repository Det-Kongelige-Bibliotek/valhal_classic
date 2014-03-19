# -*- encoding : utf-8 -*-

# The helper methods for dissemination.
# Currently only for dissemination through BifrostBøger.
module DisseminationService
  require 'active_support/core_ext/hash/conversions'
  include MqHelper # methods: send_message_to_bifrost_books

  # constant for BifrostBooks type.
  DISSEMINATION_TYPE_BIFROST_BOOKS = 'BifrostBøger'

  # Disseminate a DOD-work
  # @param work The work with the DOD-book to disseminate
  # @param options The message containing the URL for the PDF.
  # @param type The type for dissemination
  def disseminate(work, options, type)
    message = create_message(work, options, type)
    send_message_to_bifrost_books(message)
  end

  private
  # Creates a message depending on the dissemination type
  # Currently only BifrostBøger supported.
  def create_message(work, options, type)
    case type
      when DISSEMINATION_TYPE_BIFROST_BOOKS
        create_message_for_dod_book(work, options)
      else
        raise ArgumentError.new("Cannot disseminate type #{type}")
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
  # @param options The options for the message containing the fileUri.
  # @return The message in JSON format.
  def create_message_for_dod_book(work, options)
    if options['fileUri'].blank?
      raise ArgumentError.new("Cannot handle dod book without any file URI.")
    end
    message = Hash.new
    message['UUID'] = work.uuid
    message['Dissemination_type'] = 'BifrostBøger'
    message['Type'] = work.pid
    # TODO this is a hack, since we currently cannot handle more than url.
    message['Files'] = {'1' => options['fileUri']}
    mods_xml = Nokogiri::XML.parse(work.descMetadata.content)
    message['MODS'] = Hash.from_xml(mods_xml.to_s)

    message.to_json
  end
end
