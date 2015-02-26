set :stage, :qburst
set :rails_env, :qburst

set :application, 'stayntouchpms'

set :repo_url, 'git@codebase.qburst.com:dipin/stayntouchpms.git'

set :scm, :git

set :deploy_to, '/home/stayntouch/staging/pms'

set :branch, 'ng-develop'

set :deploy_via, :remote_cache

set :rails_env, 'qburst'

set :pty, true

set :default_env,
    path: '/home/stayntouch/.rvm/gems/ruby-1.9.3-p448/bin:/home/stayntouch/.rvm/gems/ruby-1.9.3-p448@global/bin:/home/stayntouch/.rvm/rubies/ruby-1.9.3-p448/bin:/home/stayntouch/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/rvm/bin',
    gem_home: '/home/stayntouch/.rvm/gems/ruby-1.9.3-p448',
    gem_path: '/home/stayntouch/.rvm/gems/ruby-1.9.3-p448:/home/stayntouch/.rvm/gems/ruby-1.9.3-p448@global'

set :rake, '/home/stayntouch/.rvm/gems/ruby-1.9.3-p448/bin/rake'
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# role :app, %w{10.7.1.17}
# role :web, %w{10.7.1.17}
# role :db,  %w{10.7.1.17}
set :linked_files, %w(config/database.yml)
# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '10.7.1.17', user: 'stayntouch', roles: %w(web app db), my_property: :my_value, password: 'IH*g89J',
                    ssh_options: {
                      user: 'stayntouch',
                      forward_agent: false,
                      auth_methods: %w(publickey password),
                      password: 'IH*g89J'
                    }

namespace :db_empty do
  task :empty do
    on roles(:web) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:migrate:reset'
        end
      end
    end
  end
end

namespace :data_seed do
  desc 'reload the database with seed data'
  task :seed do
    on roles(:web) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end

namespace :import do
  desc 'import rooms'
  task :rooms do
    on roles(:web) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'pms_qburst:room_number_import'
        end
      end
    end
  end

  desc 'import room status'
  task :room_status do
    on roles(:web) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'pms_qburst:room_status_import[1]'
        end
      end
    end
  end

  desc 'import reservations'
  task :reservations do
    on roles(:web) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'pms:res_import[1]'
        end
      end
    end
  end
end

namespace :test_data_seed do
  desc 'reload the database with test seed data'
  task :test_seed do
    on roles(:web) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db_test:seed'
        end
      end
    end
  end
end

#before 'deploy:migrate', 'db_empty:empty'
after 'deploy:migrate', 'data_seed:seed'
after 'data_seed:seed', 'test_data_seed:test_seed'
after 'test_data_seed:test_seed', 'import:rooms'
after 'import:rooms', 'import:room_status'
after 'import:room_status', 'import:reservations'

namespace :deploy do

  # desc 'Restart application'
  # task :restart do
    # on roles(:app), in: :sequence, wait: 5 do
      # # Your restart mechanism here, for example:
      # # execute :touch, release_path.join('tmp/restart.txt')
    # end
  # end
#
  # after :restart, :clear_cache do
    # on roles(:web), in: :groups, limit: 3, wait: 10 do
      # # Here we can do anything such as:
      # # within release_path do
      # #   execute :rake, 'cache:clear'
      # # end
    # end
  # end

  after :finishing, 'deploy:cleanup'

end

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :staging)
