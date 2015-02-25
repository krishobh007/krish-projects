module Socky
  module Server
    class WebSocket < Rack::WebSocket::Application
      include Misc

      DEFAULT_OPTIONS = {
        :debug => false
      }

      attr_reader :connection

      def initialize(*args)
        super
        Config.new(@options)
        @clients = Array.new;
        puts "Server initializes...\n"
      end

      # Called when connection is opened
      def on_open(env)
        app_name = env['PATH_INFO'].split('/').last
        @connection = Connection.new(self, app_name)
        @clients.push @connection;
      end

      # Called when message is received
      def on_message(env, msg)
        log("received", msg)

        from_email, *rest = msg.split("#!#").last.split('#')
        to_email = rest.first

        if (to_email == 'broadcast')
          @clients.each do |client|
            if client != self.connection
              client.send_data(msg.split("#!#").last)
            end
          end
        else
          destination_client = Client.find(:last, :conditions => ['client_email = ?', to_email])
          puts destination_client.client_id
          self.connection.application.connections[destination_client.client_id].send_data(msg.split("#!#").last)
        end
        if (msg.split("#!#").first == 'sajith123')
          begin
            current_client = Client.find(:first, :conditions => ['client_id = ?', self.connection.id])
            current_client.client_email = msg.split("#!#").last.split('#').first.gsub("\"", "")
            current_client.save
          rescue  => e
            print e.message
          end
        end
        
        
        Message.new(@connection, msg).dispath
      end

      # Called when client closes connecton
      def on_close(env)
        @clients.delete(self.connection)
        @connection.destroy if @connection
      end

      # Send JSON-encoded data instead of clear text
      def send_data(data)
        #jsonified_data = data.to_json
        log('sending', data)
        super(data)
      end
    end
  end
end
