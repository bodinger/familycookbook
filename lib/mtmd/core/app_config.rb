module MTMD
  module Core
    module AppConfig

      def api_path
        app_config['api_path']
      end

      def api_design
        app_config['design']
      end

      def api_version
        app_config['version']
      end

      def environment
        const_defined?('PADRINO_ENV') && const_get('PADRINO_ENV') ||
        const_defined?('RACK_ENV') && const_get('RACK_ENV') ||
        'development'
      end

      def config_params
        loader.load_config
      end

      def app_config
        config_params['app']
      end

      def db_config
        config_params['db']
      end

      private

      def config_file
        root('/config/environment.yml')
      end

      def loader
        MTMD::Core::ConfigLoader.new(config_file, environment)
      end

    end
  end
end
