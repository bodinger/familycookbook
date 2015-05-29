require 'sequel'

module MTMD
  class Db

    attr_reader :dbinstance, :dbconfig, :logger

    def initialize(config, logger)
      @dbconfig = config
      @logger   = logger
    end

    def get_instance
      unless @dbinstance.nil?
        return @dbinstance
      end
      @dbinstance ||= connect!(dbconfig)
      @dbinstance.loggers = [logger]
      @dbinstance
    end

    def connect!(db_config)
      db_config['database'] ||= db_config['name']

      Sequel.extension :core_extensions, :pg_range_ops, :pg_array_ops, :pg_json_ops
      Sequel::Model.plugin :update_or_create

      Sequel.postgres(db_config).tap do |db|
        db.extension :pg_array, :pg_json, :pg_range, :schema_dumper
      end
    end

    def local?
      environment = const_try('RACK_ENV')        ||
                    const_try('PADRINO_ENV')     ||
                    const_try('ENV')['RACK_ENV'] ||
                    const_try('ENV')['ENV']

      raise 'You must specify an environment.' unless environment

      %w{test development}.include? environment
    end

    def self.const_try(name)
      const_defined?(name) && const_get(name)
    end
    private_class_method :const_try
  end
end
