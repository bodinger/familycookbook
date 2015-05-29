module MTMD
  module Core
    module ThreadsafePadrino

      module EagerCompilingRouting

        # compile routes eagerly, since it is not threadsafe
        def setup_application!
          super
          compiled_router.to_s # to_s compiles as a side effect
        end

      end


      def self.registered(app)
        app.extend EagerCompilingRouting
      end

    end
  end
end
