# Helper methods defined here can be accessed in any controller or view in the application

module MTMD
  module FamilyCookBook
    module ModelsHelper

      def ingredients_options
        MTMD::FamilyCookBook::Ingredient.
          order(:title).
          select_map([:title, :id])
      end

      def ingredient_types_options
        MTMD::FamilyCookBook::IngredientType.
          order(:title).
          select_map([:title, :id])
      end

      def units_options
        units = MTMD::FamilyCookBook::Unit.
          order(:name)
        units.each_with_object([]) do |unit, agg|
          agg << ["#{unit.name} (#{unit.short_name})", unit.id]
        end
      end

      def tags_options
        MTMD::FamilyCookBook::Tag.
          order(:name).
          select_map([:name, :id])
      end

      def portions_value(recipe)
        default_value = MTMD::FamilyCookBook::IngredientQuantity::DEFAULT_PORTIONS
        return default_value unless recipe.ingredient_quantities.first
        return default_value unless recipe.ingredient_quantities.first.portions
        recipe.ingredient_quantities.first.portions
      end

    end
  end
end

MTMD::FamilyCookBook::App.helpers MTMD::FamilyCookBook::ModelsHelper
