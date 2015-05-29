# Multiproduction configuration for integration environment

set :rack_env, 'integration'
set :deploy_env, 'integration'
set :deploy_to, "/data/www/cdb/#{application}/#{version}/#{deploy_env}"
set :branch, 'master'

set :nginx_server_names, [ "192.168.178.197" ]

server "none", :app, :web
server "none", :app, :web
