# -*- encoding : utf-8 -*-

# Provides methods for all elements for sending a message over ActiveMQ
module MqHelper
  # Sends a message containing the UUID of the element, the metadata for the element, and optionally the URI for the content-data.
  #
  # The message format:
  # UUID: 'uuid for the element'
  # CONTENT_URI: 'url for downloading the content metadata' (optional)
  # METADATA: 'the metadata for the element'
  #
  # TODO: figure out whether to use ActiveMQ and STOMP, as in this case.
  #
  # @param uuid The UUID for the given element
  # @param metadata The metadata for the element
  # @param content_uri The URI for extracting the content files.
  def send_message_to_preservation(uuid, metadata, content_uri)
    uri = MQ_CONFIG["activemq"]["broker_uri"]
    destination = MQ_CONFIG["activemq"]["preservation_destination"]

    message = "UUID: #{uuid}\n\nContent_URI: #{content_uri}\n\nMETADATA: #{metadata}"
    logger.info "Sending message '#{message}' on destination '#{destination}' at broker '#{uri}'"

    # Stop sending, since it does not work for testing environment.
    #client = Stomp::Client.new(uri)
    #client.publish(destination, message)
  end
end
