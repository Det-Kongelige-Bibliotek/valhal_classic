# -*- encoding : utf-8 -*-
require 'bunny'

# Provides methods for all elements for sending a message over RabbitMQ
module MqHelper
  # Sends a preservation message on the MQ.
  #
  # @param message The message content to be sent on the preservation destination.
  def send_message_to_preservation(message)
    destination = MQ_CONFIG['preservation']['destination']

    send_on_rabbitmq(message, destination)
  end

  private
  # Sends a given message at the given destination on the MQ with the uri in the configuration.
  # @param message The message content to send.
  # @param destination The destination on the MQ where the message is sent.
  # @return Weather the message successfully is sent.
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
