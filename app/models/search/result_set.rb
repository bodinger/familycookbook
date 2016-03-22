module MTMD
  module FamilyCookBook
    module Search
      class ResultSet
        TABLE_CONFIG = {
          :phrase       => '',
          :controller   => nil,
          :action       => nil,
          :results      => [],
          :table_config => {
            :header => [],
            :body   => []
          }
        }

        def initialize(opts = {})
          @result_set = TABLE_CONFIG.merge(
            {
              :phrase       => opts.fetch(:phrase),
              :controller   => opts.fetch(:controller),
              :action       => opts.fetch(:action),
              :results      => opts.fetch(:results),
              :table_config => opts.fetch(:table_config)
            }
          )
        end

        def get
          @result_set
        end
      end
    end
  end
end
