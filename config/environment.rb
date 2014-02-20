# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

APP_VERSION = `git describe --tags --abbrev=0` unless defined? APP_VERSION

ActionView::Base.field_error_proc = Proc.new {|html, instance| html }

# Initialize the rails application
Valhal::Application.initialize!

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      logger.debug "Forked"
      # We’re in a smart spawning mode
      # Now is a good time to connect to RabbitMQ
      listen_to_queue
    end
  end
else
  # We're in direct spawning mode. We don't need to do anything.
end

