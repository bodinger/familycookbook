module MTMD
  module Core
    module CommonLogger

      module Middleware

        module AllowPrepend
          # Padrino lacks an option to prepend (instead of append) middlewares
          # extending this into an application will fix that

          def prepend_middleware(middleware, *args, &block)
            @prepend_middleware ||= []
            @prepend_middleware << [middleware, args, block]
          end

          def setup_default_middleware(builder)
            (@prepend_middleware || []).each do |middleware, args, block|
              builder.use(middleware, *args, &block)
            end
            super
          end
        end

        class SetNamespace

          def initialize(app, namespace)
            @app = app
            @namespace = namespace
          end

          def call(env)
            CommonLogger.with_logger_namespace(@namespace) do
              @app.call(env)
            end
          end

        end

      end


      def self.loggers
        Thread.current[:MTMD_Core_CommonLogger_loggers] ||= {}
      end

      def self.with_logger_namespace(namespace)
        old_logger = Padrino.logger
        set_logger(namespace)
        yield
      ensure
        Padrino.logger = old_logger
      end

      def self.set_logger(namespace)
        existing_logger = loggers[namespace]
        if existing_logger
          Padrino.logger = existing_logger
        else
          logger = new_logger(namespace)
          Padrino.logger = logger
          logger.colorize!
          loggers[namespace] = logger
        end
      end

      def self.new_logger(namespace)
        path = File.join(Padrino.root('log'), [Padrino.env, namespace, 'log'].compact.join('.'))
        template = lambda do |e|
          "[#{e.time.strftime("%FT%T.%L")} #{e.severity_label} #{e.progname}(#{e.pid})] #{e.message}"
        end
        config = Padrino::Logger::Config[Padrino.env.to_sym][:log_level]
        log_level = Lumberjack::Logger.const_get( config.to_s.upcase.to_sym )
        logger = Lumberjack::Logger.new( path,
                                         :level         => log_level,
                                         :flush_seconds => 10,
                                         :progname      => "fcb",
                                         :template      => template )
        logger
      # :nocov:
        rescue StandardError => e
          raise(
            "Logger Error: Unable to access log file. Please ensure that exists and is chmod 0666.\n" +
            "The log level has been raised to WARN and the output directed to STDERR until the problem is fixed.\n" +
            "Exact Error was: #{e.inspect}"
          )
      end
      # :nocov:


      def self.registered(app)
        set_logger(nil)

        app.extend(Middleware::AllowPrepend)
        app.prepend_middleware(Middleware::SetNamespace, app.logger_namespace) if app.respond_to?(:logger_namespace)

        app.before do
          @start_time = (Time.now.to_f * 1000.0).to_i

          logger.debug("--------------------------")
          logger.debug("RECEIVED: #{request.request_method}: #{request.path}")
          logger.debug("PARAMS: #{params}")
          logger.debug("ENVIRONMENT: #{PADRINO_ENV}")
          logger.debug("--------------------------")
        end

        app.after do
          logger.debug("ELAPSED: #{request.request_method}: #{request.path}: (#{(Time.now.to_f * 1000.0).to_i - @start_time}ms)")
        end
      end
    end

  end
end
