module MTMD
  module FamilyCookBook
    module Search
      class Recipe
        CONTROLLER   = :recipe
        ACTION       = :show
        TABLE_CONFIG = {
          :header => [
            {
              :title => 'Title',
              :width => 12
            }
          ],
          :body => [
            {
              :field => :title,
              :width => 12
            }
          ]
        }

        def search(phrase)
          build_result(
            phrase,
            query(phrase)
          )
        end

        def transform_phrase(phrase)
          phrase
        end

        def build_result(phrase, results)
          MTMD::FamilyCookBook::Search::ResultSet.new(
            :controller   => CONTROLLER,
            :action       => ACTION,
            :table_config => TABLE_CONFIG,
            :phrase       => transform_phrase(phrase),
            :results      => results
          )
        end
      end
    end
  end
end
