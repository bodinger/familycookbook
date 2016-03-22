module MTMD
  module FamilyCookBook
    module Search
      class RecipeByIngredient
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

        def query(phrase)
          MTMD::FamilyCookBook::Recipe.
            where(
              :id => MTMD::FamilyCookBook::Ingredient.
                association_join(:ingredient_quantities).
                where(Sequel.ilike(:ingredients__title, "%#{phrase}%")).
                select_map(:recipe_id)
            ).
            order(:title).
            all
        end

        def build_result(phrase, results)
          MTMD::FamilyCookBook::Search::ResultSet.new(
            :controller   => CONTROLLER,
            :action       => ACTION,
            :table_config => TABLE_CONFIG,
            :phrase       => phrase,
            :results      => results
          ).get
        end
      end
    end
  end
end
