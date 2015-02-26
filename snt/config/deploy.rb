set :application, 'StayNTouch'
set :repo_url, 'git@github.com:StayNTouch/pms.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/pms'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w(config/database.yml config/resque.yml config/email.yml)
set :linked_dirs, %w(log public/system certs/mli pids sockets)

set :npm_target_path, -> { release_path.join('app/assets') }
set :npm_flags, nil
set :grunt_target_path, -> { release_path.join('app/assets') }
set :grunt_tasks, 'clean ngtemplates concat'

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Flush memcached, seed, restart unicorn and god'
  task :restart do
    if fetch(:stage) == :production || fetch(:stage) == :release || fetch(:stage) == :qa
      invoke 'seed'
    else
      invoke 'test_seed'
    end

    if fetch(:stage) != :qburst
      invoke 'unicorn:restart'
      invoke 'memcached:flush'
    end

    invoke 'god:restart'
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

  desc 'Provision env before assets:precompile'
  task :fix_bug_env do
    set :rails_env, (fetch(:rails_env) || fetch(:stage))
    set :rails_root, current_path
  end

  before 'deploy:assets:precompile', 'deploy:fix_bug_env'
  before 'deploy:updated', 'grunt'
end

# Unicorn tasks
namespace :unicorn do
  def pid_path
    "#{shared_path}/pids/unicorn.pid"
  end

  def socket_path
    "#{shared_path}/sockets/unicorn.sock"
  end

  def pid_exists?
    'true' ==  capture("if [ -e #{pid_path} ]; then echo 'true'; fi").strip
  end

  def check_pid_path_then_run(command)
    if pid_exists?
      execute command
    else
      info "Unicorn master worker wasn't found, possibly wasn't started at all. Try run unicorn:start first"
    end
  end

  def start
    within current_path do
      execute :bundle, "exec unicorn_rails -c config/unicorn.rb -D -E #{fetch(:rails_env)}"
    end
  end

  desc 'Starts the Unicorn server'
  task :start do
    on roles(:app) do
      execute "mkdir -p #{File.dirname(pid_path)}"
      execute "mkdir -p #{File.dirname(socket_path)}"

      if !pid_exists?
        start
      else
        info "Unicorn is already running at PID: `cat #{pid_path}`"
      end
    end
  end

  desc 'Stops Unicorn server'
  task :stop do
    on roles(:app) do
      check_pid_path_then_run "kill -s QUIT `cat #{pid_path}`"
    end
  end

  desc 'Zero-downtime restart of Unicorn'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      if pid_exists?
        execute "kill -USR2 `cat #{pid_path}`"
      else
        start
      end
    end
  end

  before :start, 'rvm:hook'
  before :restart, 'rvm:hook'
end

namespace :god do
  desc 'Start god'
  task :start do
    on roles(:god) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec god -c config/resque.god'
        end
      end
    end
  end

  desc 'Stop god'
  task :stop do
    on roles(:god) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec god terminate'
        end
      end
    end
  end

  desc 'Restart god'
  task :restart do
    invoke 'god:stop'
    invoke 'god:start'
  end

  before :start, 'rvm:hook'
  before :stop, 'rvm:hook'
end

namespace :resque do
  desc 'Use god to restart resque workers and schedule'
  task :reload do
    on roles(:god) do
      execute 'god stop resque_scheduler'
      execute 'god stop resque'
      execute "god load #{current_path}/config/resque.god"
      execute 'god start resque'
      execute 'god start resque_scheduler'
    end
  end

  before 'resque:reload', 'god:start'
end

namespace :memcached do
  desc 'Flush memcached'
  task :flush do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'memcached:flush'
        end
      end
    end
  end

  before :flush, 'rvm:hook'
end

# namespace :npm do
#   desc 'npm Install'
#   task :install do
#     on roles(:app) do
#       execute "cd #{current_path}/app/assets && npm install"
#     end
#   end

#   before :install, 'rvm:hook'
# end
