module MTMD
  module Core
    class ConfigLoader

      attr_accessor :config_file_path, :environment, :params

      def initialize(config_file_path, env = nil)
        @config_file_path = config_file_path
        @environment = env
        load_config
      end

      def load_config
        return @params if @params

        config = YAML.load_file( config_file_path )
        @params = if environment && environment.size > 0
                    config[environment.to_s]
                  else
                    config
                  end
      end
    end
  end
end
