module MTMD
  module FamilyCookBook
    module Search
      class RecipeByIngredientType < ::MTMD::FamilyCookBook::Search::Recipe

        def query(phrase)
          MTMD::FamilyCookBook::Recipe.
            where(
              :id => MTMD::FamilyCookBook::Ingredient.
                association_join(:ingredient_quantities).
                where(:ingredient_type_id => phrase).
                select_map(:recipe_id)
            ).
            order(:title).
            all
        end

        def transform_phrase(phrase)
          MTMD::FamilyCookBook::IngredientType.where(:id => phrase).select_map(:title).first
        end

      end
    end
  end
end
