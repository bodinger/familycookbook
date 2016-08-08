require 'fileutils'
require 'yaml'

set :stages, %w(production staging integration)
set :default_stage, "production"

require 'capistrano/ext/multistage'

set :application, 'familycookbook'
set :version, 'v1'
set :user, 'fcb'
set :runner, 'fcbrun'

# require additional recipes
#require_relative 'deploy/recipes/config'
#require_relative 'deploy/recipes/puma'
#require_relative 'deploy/recipes/shared_dirs'
#require_relative 'deploy/recipes/nginx'

# =============================================================================
# Basic variables
# =============================================================================

set :project_root, FileUtils.pwd
set :deploy_via, :copy

set :copy_exclude, [ ".git", ".gitignore", "log", "tmp" ]

#set :shared_dirs, ["sockets"]
set :conf_templates, ["config/puma.conf"]

# set :bundle_flags, "--quiet --no-cache" #only needed after ruby update, investigate why? https://github.com/bundler/bundler/issues/1454

set :repository, "."
set :keep_releases, 5

set :scm, :git
set :use_sudo, false
# Don't check for images
set :normalize_asset_timestamps, false

default_run_options[:pty] = true

ssh_options[:port] = 22

after "deploy:update", "deploy:cleanup"


# =============================================================================
# RVM
# =============================================================================

# Integration via the rvm capistrano plugin

require 'rvm/capistrano'

set :rvm_ruby_string, File.read('.ruby-version').strip
set :rvm_type, :user


# =============================================================================
# nginx
# =============================================================================

set :nginx_port, 80
set :api_root_path, '~ ^/familycookbook/' # with leading /


# =============================================================================
# Bundler integration
# =============================================================================

require "bundler/capistrano"


# =============================================================================
# Puma integration
# =============================================================================

# Please see the puma integration in cdb-core/deploy/recipes

set :puma_user,                 lambda { "#{runner}" }
set :puma_port,                 lambda { "3019" }
set :puma_workers,              lambda { "1" }
set :puma_threads,              lambda { "1,4" }
set :puma_pidfile,              lambda { "#{fetch(:deploy_to)}/shared/pids/puma.pid" }
set :puma_activate_control_app, lambda { "unix://#{fetch(:deploy_to)}/shared/sockets/pumactl.sock" }
set :puma_state_path,           lambda { "#{fetch(:deploy_to)}/shared/sockets/puma.state" }
