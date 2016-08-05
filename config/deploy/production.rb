# Multistage configuration for production environment
server "mtmd.de", :app, :web, :db, :primary => true

set :rack_env, 'production'
set :deploy_env, 'production'
set :deploy_to, "/var/www/vhosts/mtmd.de/#{application}/#{version}/#{deploy_env}"
set :branch, 'production'

