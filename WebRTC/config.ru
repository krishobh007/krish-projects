# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
current_dir = File.expand_path(File.dirname(__FILE__))
require current_dir + '/lib/socky/server'
# require 'socky/server'

options = {
  :config_file => current_dir + '/example/config.yml',
  :debug => true
}

map '/websocket' do
  run Socky::Server::WebSocket.new options
  #run MyServer.new
  #run MyApp.new
end

map '/http' do
  run Webrtc::Application
end
