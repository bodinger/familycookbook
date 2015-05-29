# Multiproduction configuration for production environment

set :rack_env, 'production'
set :deploy_env, 'production'
set :deploy_to, "/data/www/cdb/#{application}/#{version}/#{deploy_env}"
set :branch, 'production'

set :nginx_server_names, [ "192.168.178.197" ]

server "none", :app, :web
server "none", :app, :web
