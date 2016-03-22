require_relative '../lib/mtmd/core/threadsafe_padrino'

module MTMD
  module FamilyCookBook
    extend MTMD::Core::AppConfig

    def self.root(path)
      Padrino.root(path)
    end

    def self.app_config
      config_params['config']
    end

    class App < Padrino::Application
      register Padrino::Mailer
      register Padrino::Helpers
      enable :sessions
    end
  end
end
