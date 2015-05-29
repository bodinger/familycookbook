# Multiproduction configuration for staging environment

set :rack_env, 'staging'
set :deploy_env, 'staging'
set :deploy_to, "/data/www/cdb/#{application}/#{version}/#{deploy_env}"
set :branch, 'staging'

set :nginx_server_names, [ "192.168.178.197" ]

server "none", :app, :web
server "none", :app, :web
