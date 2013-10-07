# -*- encoding : utf-8 -*-

# Provides methods for all elements for sending a message over ActiveMQ
module ActivemqHelper
  # Sends a message containing the UUID of the element, the metadata for the element, and optionally the URI for the content-data.
  # @param uuid The UUID for the given element
  # @param metadata The metadata for the element
  # @param content_uri The URI for extracting the content files.
  def send_activemq_message(uuid, metadata, content_uri)
    uri = ACTIVE_MQ_CONFIG["activemq"]["uri"]
    destination = ACTIVE_MQ_CONFIG["activemq"]["destination"]

    client = Stomp::Client.new(uri)
    message = "UUID: #{uuid}\n\nContent_URI: #{content_uri}\n\nMETADATA: #{metadata}"
    logger.info "Sending message '#{message}' on destination '#{destination}' at broker '#{uri}'"
    client.publish(destination, message)
  end
end
