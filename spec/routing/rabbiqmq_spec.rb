# -*- encoding : utf-8 -*-
require 'amqp'
require 'bunny'

describe 'Advanced Message Queue Protocol' do
  #describe 'amqp gem' do
  #  it 'should send a message on a channel' do
  #    pending "Not a test!"
  #    EventMachine.run do
  #      connection = AMQP.connect(:host => '127.0.0.1')
  #      puts "Connecting to RabbitMQ. Running #{AMQP::VERSION} version of the gem..."
  #
  #      ch  = AMQP::Channel.new(connection)
  #      q   = ch.queue("amqpgem.examples.hello_world", :auto_delete => true)
  #      x   = ch.default_exchange
  #
  #      q.subscribe do |metadata, payload|
  #        puts "Received a message: #{payload}. Disconnecting..."
  #
  #        connection.close {
  #          EventMachine.stop { exit }
  #        }
  #      end
  #
  #      x.publish "Hello, world!", :routing_key => q.name
  #    end
  #  end
  #
  #  it 'should send a message' do
  #    pending "Not a test!"
  #    uri = 'amqp://localhost'
  #    destination = 'dev-queue'
  #    AMQP.start(uri) do |connection|
  #      channel = AMQP::Channel.new(connection)
  #      exchange = channel.default_exchange
  #      exchange.publish("Ohai!", :routing_key => destination)
  #
  #      EventMachine.add_timer(2) do
  #        exchange.delete
  #
  #        connection.close { EventMachine.stop }
  #      end
  #    end
  #  end
  #end

  describe 'bunny gem' do
    it 'should send a message' do
      #pending "Should not be run on CI"
      uri = 'amqp://localhost'
      destination = 'dev-queue'

      conn = Bunny.new(uri)
      conn.start
      ch = conn.create_channel
      x  = ch.default_exchange

      x.publish("Hello!", :routing_key => destination)

      conn.close
    end
  end
end
