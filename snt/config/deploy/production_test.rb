set :stage, :production_test
set :rails_env, :production_test
set :branch, 'release'

set :keep_releases, 2

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w(snt@pms-prod-test.stayntouch.com)
role :web, %w(snt@pms-prod-test.stayntouch.com)
role :db,  %w(snt@pms-prod-test.stayntouch.com)
role :god, %w(snt@pms-prod-test.stayntouch.com)

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'pms-prod-test.stayntouch.com', user: 'snt', roles: %w(web app)
