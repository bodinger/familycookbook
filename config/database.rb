require_relative '../lib/mtmd/core/path_helper'
require_relative '../lib/mtmd/core/config_loader'

module MTMD
  module FamilyCookBook
    class Database

      def self.config
        base_config = MTMD::Core::ConfigLoader.new(::Utils::PathHelper.project_root('config/database.yml'), RACK_ENV).load_config
        base_config['database']
      end

      def self.host
        config['host']
      end

      def self.credentials
        "#{config['user']}:#{config['password']}" if config['user']
      end

      def self.db
        config['name']
      end

      def self.port
        config['port'] || "5432"
      end

      def self.options
        config['pg_options'] || {}
      end

      def self.handler
        "postgres://#{credentials}@#{host}:#{port}/#{db}"
      end

    end
  end
end



Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = true # Do not throw exceptions on failure
Sequel::Model.plugin :update_or_create
Sequel.extension :core_extensions, :pg_range_ops, :pg_array_ops, :pg_json_ops

loggers = RACK_ENV == 'test' ? [] : [logger]
default_options = {:loggers => loggers}
Sequel::Model.db = Sequel.connect(
  MTMD::FamilyCookBook::Database.handler,
  default_options.merge(MTMD::FamilyCookBook::Database.options)
)
Sequel::Model.db.extension :pagination, :pg_array, :pg_json, :pg_range, :schema_dumper
