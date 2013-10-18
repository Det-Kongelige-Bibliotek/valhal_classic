# -*- encoding : utf-8 -*-
require 'bunny'

describe 'Advanced Message Queue Protocol' do
  describe 'bunny gem' do
    it 'should send a message' do
      pending "Should not be run on CI"
      uri = MQ_CONFIG["broker_uri"]
      destination = MQ_CONFIG["preservation"]["destination"]

      conn = Bunny.new(uri)
      conn.start
      ch = conn.create_channel
      x  = ch.default_exchange

      x.publish("Hello!", :routing_key => destination)

      conn.close
    end
  end
end
