require 'resque/server'
require 'resque_scheduler'
require 'resque_scheduler/server'

Resque::Scheduler.dynamic = true

# resque-logger config

log_path = File.join Rails.root, 'log'

config = {
  folder:     log_path,                 # destination folder
  class_name: Logger,                   # logger class name
  class_args: ['daily', 1.kilobyte],  # logger additional parameters
  level:      Logger::DEBUG,            # optional
  formatter:  Logger::Formatter.new,    # optional
}

Resque.logger_config = config
