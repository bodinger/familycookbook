require 'bundler/setup'
require 'padrino-core/cli/rake'
require 'rspec/core/rake_task'
require 'sequel'
require_relative 'lib/mtmd/core/config_loader'
require_relative 'lib/mtmd/core/config'

require_relative 'lib/mtmd/db'
require_relative 'lib/mtmd/tasks/db'
Sequel.extension :migration

PadrinoTasks.use(:sequel)
PadrinoTasks.use(:database)
PadrinoTasks.init
