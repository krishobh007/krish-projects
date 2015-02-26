class RoverQueue
  @@started = false
  
  def self.start
    if not @@started
      self.connection.start
      @@started = true
    end
  end
  
  def self.connection
    @connection ||= Bunny.new
  end
  
  def self.channel
    if not @@started
      self.start
    end
    @channel ||= connection.create_channel
  end
  
  def self.queue(queue_identifier)
    self.channel.queue(queue_identifier)
  end
  
  def self.exchange
    self.channel.default_exchange
  end
  
  def self.publish(queue_identifier, publish_data)
    routing_key = self.queue(queue_identifier).name
    self.exchange.publish publish_data, :routing_key => routing_key
  end
end