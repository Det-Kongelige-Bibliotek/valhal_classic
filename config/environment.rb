# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

APP_VERSION = `git describe --tags --abbrev=0` unless defined? APP_VERSION

ActionView::Base.field_error_proc = Proc.new {|html, instance| html }

# Initialize the rails application
Valhal::Application.initialize!

# In tests, then MQ uri will be overridden by the environment variable 'MQ_URI'
if Rails.env.upcase == 'TEST' && !ENV['MQ_URI'].blank?
  MQ_CONFIG['mq_uri'] = ENV['MQ_URI']
  puts "Setting test MQ settings from environment variables: #{MQ_CONFIG.inspect}"
end

include MqListenerHelper
include DigitisationHelper

# Connect to the RabbitMQ broker, and initialize the listeners
def initialize_listeners
  uri = MQ_CONFIG["mq_uri"]
  conn = Bunny.new(uri)
  conn.start
  ch = conn.create_channel

  subscribe_to_preservation(ch)
  subscribe_to_dod_digitisation(ch)
  conn.close
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
    begin
      logger.debug "Received the following preservation response message: #{payload}"
      handle_preservation_response(JSON.parse(payload))
    rescue => e
      logger.error "Try to handle preservation response message: #{payload}\nCaught error: #{e}"
    end
  end
end

#This function starts the listener thread which will poll RabbitMQ at regular intervals set by the polling_interval
def start_listener_thread
  polling_interval = MQ_CONFIG['preservation']['polling_interval_in_minutes']
  Thread.new do
    while true
      initialize_listeners
      logger.debug "Going to sleep for #{polling_interval} minutes..."
      sleep polling_interval.minutes
    end
  end
  #I've read here: https://www.agileplannerapp.com/blog/building-agile-planner/rails-background-jobs-in-threads
  #that each thread started in a Rails app gets its own database connection so when the thread terminates we need
  #to close any database connections too.
  ActiveRecord::Base.connection.close
end

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      logger.debug "Forked"
      # We’re in a smart spawning mode
      # Now is a good time to connect to RabbitMQ
      start_listener_thread
    end
  end
else
  if Rails.env.upcase != 'TEST'
    start_listener_thread
  end
  # We're in direct spawning mode. We don't need to do anything.
end

