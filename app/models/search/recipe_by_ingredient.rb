module MTMD
  module FamilyCookBook
    module Search
      class RecipeByIngredient < ::MTMD::FamilyCookBook::Search::Recipe

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

      end
    end
  end
end
