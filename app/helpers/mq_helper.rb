# -*- encoding : utf-8 -*-
require 'bunny'

# Provides methods for all elements for sending a message over RabbitMQ
module MqHelper
  # Sends a preservation message on the MQ.
  #
  # @param message The message content to be sent on the preservation destination.
  def send_message_to_preservation(message)
    destination = MQ_CONFIG['preservation']['destination']

    send_on_rabbitmq(message, destination, {
        'content_type' => 'application/json',
        'type' => Constants::MQ_MESSAGE_TYPE_PRESERVATION_REQUEST
        })
  end

  def read_message_from_digitisation
    source_queue = MQ_CONFIG['digitisation']['source']
    logger.info "source queue name: #{source_queue}"
    #Object msg = read_from_rabbitmq(source_queue, options={})
    #logger.debug "Msg received from digitisation queue: #{msg.to_s}"
  end

  private
  # Sends a given message at the given destination on the MQ with the uri in the configuration.
  # @param message The message content to send.
  # @param destination The destination on the MQ where the message is sent.
  # @param options Is a hash with header values for the message, e.g. content-type, type.
  # @return True, if the message is sent successfully. Otherwise false
  def send_on_rabbitmq(message, destination, options={})
    uri = MQ_CONFIG['mq_uri']
    logger.info "Sending message '#{message}' on destination '#{destination}' at broker '#{uri}'"

    conn = Bunny.new(uri)
    conn.start

    ch   = conn.create_channel
    q    = ch.queue(destination, :durable => true)

    q.publish(message, :routing_key => destination, :persistent => true, :timestamp => Time.now.to_i,
              :content_type => options['content_type'], :type => options['type']
    )

    conn.close
    true
  end

  #Connect to RabbitMQ and listen to messages from the source queue
  def read_from_rabbitmq(source_queue, options={})
    uri = MQ_CONFIG['mq_uri']
    logger.info "Reading message from source queue '#{source_queue}' at broker '#{uri}'"

    begin
      conn = Bunny.new(uri)
      conn.start

      ch = conn.create_channel
      q = ch.queue(source_queue, :durable => true)

      q.subscribe(:block => true) do |delivery_info, properties, body|
        puts " [x] Received #{body}"
        logger.info " [x] Received #{body}"

        # cancel the consumer to exit
        delivery_info.consumer.cancel
      end
      conn.close
    rescue Bunny::TCPConnectionFailed => e
      logger.error "Connection to #{uri} failed"
      logger.error e.to_s
    rescue Bunny::PossibleAuthenticationFailureError => e
      logger.error "Could not authenticate while connecting to #{uri}"
      logger.error e.to_s
    rescue Bunny::PreconditionFailed => e
      logger.error "Channel-level exception! Code: #{e.channel_close.reply_code}, message: #{e.channel_close.reply_text}"
    end
  end

end
