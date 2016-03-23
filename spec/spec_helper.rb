require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development, :test)
require 'bundler/setup'
require 'rspec/collection_matchers'
require 'database_cleaner'
require 'webmock/rspec'
require 'awesome_print'
require 'fabrication'
require 'faker'
require 'oj'
require 'rack/test'
require 'uri'
require 'pry'
require 'timecop'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/script'
  add_filter '/vendor'
end

require 'video_api'
require 'video_api/path_helper'
require 'pry'

ENV["RACK_ENV"] = "test"

require_relative '../lib/video_api/importer/config'
CONFIG = VideoApi::Importer::Config.new('test')

DB_CONNECTION = VideoApi.db_connect!(CONFIG.db_config)

DB_CONNECTION.loggers << VideoApi::Util::Logger.instance

def spec_root
  @spec_root ||= File.dirname( __FILE__ )
end

def project_root
  @project_root ||= File.expand_path(File.join( spec_root, '..' ))
end

Fabrication.configure do |config|
  fabricator_gem_path = VideoApi::PathHelper.fabricator_relative_path_from(Dir.pwd)
  config.fabricator_path.push(fabricator_gem_path)
end

Dir[ File.join( spec_root, 'support', '**', '*.rb' ) ].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rspec
  config.color = true
  config.formatter = 'documentation'
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.include(MockHelper)
  config.include(WatcherHelper)
  config.include(FixtureHelper)
  config.include(LoggerHelper)
  config.include(EventsHelper)
  config.include(ElasticResourceHelper)
  config.include(JsonResponseHelper)

  # Database Cleaner configuration
  config.before(:suite) do
    DatabaseCleaner[:sequel, {:connection => DB_CONNECTION}]

    DatabaseCleaner[:sequel].strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end

  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
