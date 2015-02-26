rails_env   = ENV['RAILS_ENV']  || "development"
rails_root  = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/..'
num_workers = (rails_env == 'production' || rails_env == 'production_test') ? 5 : 2

def generic_monitoring(w)
# restart if memory gets too high
w.transition(:up, :restart) do |on|
  on.condition(:memory_usage) do |c|
    c.above = 350.megabytes
    c.times = 2
  end
end

# determine the state on startup
w.transition(:init, { true => :up, false => :start }) do |on|
  on.condition(:process_running) do |c|
    c.running = true
  end
end

# determine when process has finished starting
w.transition([:start, :restart], :up) do |on|
  on.condition(:process_running) do |c|
    c.running = true
    c.interval = 5.seconds
  end

  # failsafe
  on.condition(:tries) do |c|
    c.times = 5
    c.transition = :start
    c.interval = 5.seconds
  end
end

# start if process is not running
w.transition(:up, :start) do |on|
  on.condition(:process_running) do |c|
    c.running = false
  end
end
end

num_workers.times do |num|
  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.name     = "resque-#{num}"
    w.group    = 'resque'
    w.interval = 30.seconds
    w.env      = {"QUEUE"=>"*", "RAILS_ENV"=>rails_env}
    w.start    = "bundle exec rake -f #{rails_root}/Rakefile environment resque:work"
    w.log      = "#{rails_root}/log/resque.log"
    w.err_log  = "#{rails_root}/log/resque_error.log"
      w.stop_signal = 'QUIT'
    w.stop_timeout = 20.seconds

    w.behavior(:clean_pid_file)

    generic_monitoring(w)
  end
end

God.watch do |w|
w.dir      = "#{rails_root}"
w.name     = "resque_scheduler"
w.interval = 30.seconds
w.env      = {"RAILS_ENV"=>rails_env}
w.start    = "bundle exec rake -f #{rails_root}/Rakefile environment resque:scheduler"
#w.start    = "bundle exec rake resque:scheduler"
w.log      = "#{rails_root}/log/resque_scheduler.log"
w.err_log  = "#{rails_root}/log/resque_scheduler_error.log"
w.stop_signal = 'QUIT'
w.stop_timeout = 20.seconds

w.behavior(:clean_pid_file)

generic_monitoring(w)
end

God.watch do |w|
	w.name = "Six Payment Process Server"
  	w.start = "bundle exec rake -f #{rails_root}/Rakefile environment six_payment:start_payment_processor"
  	w.keepalive
  	w.log      = "#{rails_root}/log/six_payment_server.log"
  	w.pid_file = File.join(rails_root, "tmp/pids/six_payment_server.pid")

    w.behavior(:clean_pid_file)
end
