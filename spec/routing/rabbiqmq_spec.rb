# -*- encoding : utf-8 -*-
require 'bunny'
require 'spec_helper'

describe 'Advanced Message Queue Protocol' do
  describe 'bunny gem' do
    it 'should send a message' do
      #pending "Should not be run on CI"
      uri = MQ_CONFIG["mq_uri"]
      destination = MQ_CONFIG["preservation"]["destination"]

      conn = Bunny.new(uri)
      conn.start
      ch = conn.create_channel
      q = ch.queue(destination, :durable => true)
      #x  = ch.default_exchange

      #for i in 0...100
      #  q.publish("Hello # #{i}", :routing_key => destination, :persistent => true)
      #end
      q.publish("Hello bunny!", :routing_key => destination, :persistent => true)

      q.subscribe do |delivery_info, metadata, payload|
        payload.should include 'Hello'
        #puts payload
      end


      conn.close
    end
  end
end
