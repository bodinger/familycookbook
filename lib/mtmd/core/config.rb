module MTMD
  module Core

    DEFAULT_ROOT_PATH = File.expand_path( File.join( __FILE__, '..', '..', '..', '..'))

    class Config

      DEFAULT_CONFIG_FILE_PATH = File.expand_path(File.join(DEFAULT_ROOT_PATH, 'config' ))
      BASE_CONFIG_FILE_NAME = 'database.yml'
      DEFAULT_LOG_LEVEL     = {
          :test         => :debug,
          :development  => :info,
          :integration  => :info,
          :staging      => :info,
          :production   => :warn
      }

      attr_reader :env, :root_path, :log_level, :config_file_loader, :base_config

      def initialize(env)
        @env             = env
        @root_path       = MTMD::Core::DEFAULT_ROOT_PATH
        @log_level       = DEFAULT_LOG_LEVEL[@env.to_sym]
        config_file_path = File.join(DEFAULT_CONFIG_FILE_PATH, BASE_CONFIG_FILE_NAME )
        @base_config     = MTMD::Core::ConfigLoader.new(config_file_path, env).params
      end

      def db_config
        base_config['database']
      end

      def db_url
        "postgres://#{db_credentials}#{db_config[:host]}/#{db_config[:db]}"
      end

      def db_credentials
        "#{db_config[:user]}:#{db_config[:password]}@" if db_config[:user] && db_config[:password]
      end

      def redis
        @redis ||= Redis.new(redis_params)
      end

      private

      def redis_params
        conf = base_config[:redis]
        {
            :host => conf[:host],
            :port => conf[:port],
            :db => conf[:db]
        }
      end
    end
  end
end
