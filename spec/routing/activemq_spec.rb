# -*- encoding : utf-8 -*-
require "spec_helper"

describe 'ActiveMQ' do
  describe 'STOMP access' do
    it 'should put a message on a queue' do
      pending "Are we really going to use ActiveMQ??"
      uri = "failover:(tcp://localhost:61613?keepAlive=true)"
      destination = "/topic/event"
      client = Stomp::Client.new(uri)
      message = "ronaldo #{ARGV[0]}"

      for i in (1..50)
        puts "Sending message"
        client.publish(destination, "#{i}: #{message}\n")
        puts "(#{Time.now})Message sent: #{i}"
        sleep 0.2
      end

      #client.publish(destination,  "SHUTDOWN", {'persistent'=>'false'})
      client.disconnect_receipt
    end
  end
end