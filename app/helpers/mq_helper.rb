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
  # @param content_uri The URI for extracting the content files.
  # @param metadata The metadata for the element
  def send_message_to_preservation(uuid, content_uri, metadata)
    destination = MQ_CONFIG["preservation"]["destination"]

    message = "UUID: #{uuid}\n\nContent_URI: #{content_uri}\n\nMETADATA: #{metadata}"

    send_on_rabbitmq(message, destination)
  end

  def send_on_rabbitmq(message, destination)
    uri = MQ_CONFIG["rabbitmq"]["broker_uri"]
    logger.info "Sending message '#{message}' on destination '#{destination}' at broker '#{uri}'"

    #AMQP.start(uri) do |connection|
    #  channel = AMQP::Channel.new(connection)
    #  exchange = channel.default_exchange()
    #  exchange.publish(message, :routing_key => destination)
    #
    #  EventMachine.add_timer(2) do
    #    exchange.delete
    #  end
    #end

    conn = Bunny.new(uri)
    conn.start
    ch = conn.create_channel
    x  = ch.default_exchange

    x.publish(message, :routing_key => destination)
    conn.close
  end
end
