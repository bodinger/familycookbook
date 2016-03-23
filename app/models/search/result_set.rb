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

        def controller
          @result_set[:controller]
        end

        def action
          @result_set[:action]
        end
        
        def table_config
          @result_set[:table_config]
        end

        def phrase
          @result_set[:phrase]
        end

        def results
          @result_set[:results]
        end
      end
    end
  end
end
