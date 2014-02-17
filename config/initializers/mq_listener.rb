# -*- encoding : utf-8 -*-
MQ_CONFIG = YAML.load_file("#{Rails.root}/config/mq_config.yml")[Rails.env]

# In tests, then MQ uri will be overridden by the environment variable 'MQ_URI'
if Rails.env.upcase == 'TEST' && !ENV['MQ_URI'].blank?
  MQ_CONFIG['mq_uri'] = ENV['MQ_URI']
  puts "Setting test MQ settings from environment variables: #{MQ_CONFIG.inspect}"
end

include MqListenerHelper

# Connect to the RabbitMQ broker, and initialize the listeners
def initialize_listeners
  uri = MQ_CONFIG["mq_uri"]
  conn = Bunny.new(uri)
  conn.start
  ch = conn.create_channel

  subscribe_to_preservation(ch)
end

# Subscribing to the preservation response queue
# This is ignored, if the configuration is not set.
#@param channel The channel to the message broker.
def subscribe_to_preservation(channel)
  if MQ_CONFIG["preservation"]["response"].blank?
    logger.warn 'No preservation response queue defined -> Not listening'
    return
  end

  destination = MQ_CONFIG["preservation"]["response"]
  q = channel.queue(destination, :durable => true)
  logger.info "Listening to preservation response queue: #{destination}"

  q.subscribe do |delivery_info, metadata, payload|
    logger.debug "Received the following preservation response message: #{payload}"
    set_preservation_metadata_from_message(JSON.parse(payload))
  end
end

# Handle the case when it is running on a PhusionPassenger webserver
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We’re in a smart spawning mode
      # Now is a good time to connect to RabbitMQ
      initialize_listeners
    end
  end
else
  initialize_listeners
end

