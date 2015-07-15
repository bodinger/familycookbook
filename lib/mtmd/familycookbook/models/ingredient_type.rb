module MTMD
  module FamilyCookBook
    class IngredientType < Sequel::Model(:ingredient_types)
      plugin :timestamps, :update_on_create => true

      def has_dependant_objects?
        return true if Ingredient.select(:id).where(:ingredient_type_id => id).count > 0
        false
      end

    end
  end
end
