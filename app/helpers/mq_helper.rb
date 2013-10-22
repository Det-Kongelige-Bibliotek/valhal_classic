# -*- encoding : utf-8 -*-
require 'bunny'

# Provides methods for all elements for sending a message over RabbitMQ
module MqHelper
  # Sends a message containing the UUID of the element, the metadata for the element, and optionally the URI for the content-data.
  #
  # The message format:
  # UUID: 'uuid for the element'
  # CONTENT_URI: 'url for downloading the content metadata' (optional)
  # METADATA: 'the metadata for the element'
  #
  # @param uuid The UUID for the given element
  # @param update_uri The URI for updating the preservation state
  # @param content_uri The URI for extracting the content files.
  # @param metadata The metadata for the element
  def send_message_to_preservation(uuid, update_uri, content_uri, metadata)
    destination = MQ_CONFIG['preservation']['destination']

    message = "UUID: #{uuid}\n\nUpdate_URI: #{update_uri}\n\nContent_URI: #{content_uri}\n\nMETADATA: #{metadata}"

    send_on_rabbitmq(message, destination)
  end

  private
  def send_on_rabbitmq(message, destination)
    uri = MQ_CONFIG['mq_uri']
    logger.info "Sending message '#{message}' on destination '#{destination}' at broker '#{uri}'"

    conn = Bunny.new(uri)
    conn.start
    ch = conn.create_channel
    x = ch.default_exchange

    x.publish(message, :routing_key => destination)
    conn.close
    true
  end
end
