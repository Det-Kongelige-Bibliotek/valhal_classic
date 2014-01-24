#Initializer that starts a thread for listening to messages from the digitisation queue
#and provides business logic on how to process these messages.
MQ_CONFIG = YAML.load_file("#{Rails.root}/config/mq_config.yml")[Rails.env]

#Start a background thread to listen for messages from the digitisation queue, naturally if the Rails app is stopped
#so too will this thread
polling_interval = MQ_CONFIG['digitisation']['polling_interval_in_minutes']

Thread.new do
  while true
    #listen for messages from the queue
    logger.debug "Listening for messages from digitisation workflow..."
    source_queue = MQ_CONFIG['digitisation']['source']
    logger.info "source queue name: #{source_queue}"

    uri = MQ_CONFIG['mq_uri']
    logger.info "Reading message from source queue '#{source_queue}' at broker '#{uri}'"

    begin
      conn = Bunny.new(uri)
      conn.start

      ch = conn.create_channel
      q = ch.queue(source_queue, :durable => true)
      logger.info "About to subscribe for messages"
      q.subscribe(:block => false) do |delivery_info, properties, body|
        logger.info "Subsribing.."
        puts " [x] Received #{body}"
        logger.info " [x] Received #{body}"

        # cancel the consumer to exit
        logger.info "About to cancel the consumer"
        #delivery_info.consumer.cancel
        logger.info "consumer cancelled"
      end
      logger.info "Closing connection"
      conn.close
      logger.info "connection closed"
    rescue Bunny::TCPConnectionFailed => e
      logger.error "Connection to #{uri} failed"
      logger.error e.to_s
    rescue Bunny::PossibleAuthenticationFailureError => e
      logger.error "Could not authenticate while connecting to #{uri}"
      logger.error e.to_s
    rescue Bunny::PreconditionFailed => e
      logger.error "Channel-level exception! Code: #{e.channel_close.reply_code}, message: #{e.channel_close.reply_text}"
    end

    logger.debug "Going to sleep for #{polling_interval} minutes..."
    sleep polling_interval.minutes
  end
end
#I've read here: https://www.agileplannerapp.com/blog/building-agile-planner/rails-background-jobs-in-threads
#that each thread started in a Rails app gets its own database connection so when the thread terminates we need
#to close any database connections too.
ActiveRecord::Base.connection.close