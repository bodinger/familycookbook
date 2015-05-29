# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require_relative '../lib/mtmd/core/common_logger'
Bundler.require(:default, RACK_ENV)

require 'active_support'
require 'active_support/core_ext'

Padrino::Logger::Config[:test]        = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:development] = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:integration] = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:staging]     = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:production]  = { :log_level => :warn, :stream => :to_file }

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
  require_relative 'database'
  require_relative '../lib/mtmd/familycookbook/models'
  Rabl.register!
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
  Padrino.require_dependencies Padrino.root('config/initializers/**/*.rb')
end

Padrino.load!
