module MTMD
  module FamilyCookBook
    module Search
      class RecipeByTag < ::MTMD::FamilyCookBook::Search::Recipe

        def query(phrase)
          MTMD::FamilyCookBook::Recipe.
            where(
              :id => MTMD::FamilyCookBook::Tag.
                association_join(:recipes).
                where(:tags__id => phrase).
                select_map(:recipe_id)
            ).
            order(:title).
            all
        end

        def transform_phrase(phrase)
          MTMD::FamilyCookBook::Tag.where(:id => phrase).select_map(:name).first
        end

      end
    end
  end
end
