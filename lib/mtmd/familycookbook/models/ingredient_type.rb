module MTMD
  module FamilyCookBook
    class IngredientType < Sequel::Model(:ingredient_types)
      plugin :timestamps, :update_on_create => true

      def has_dependant_objects?
        return true if Ingredient.select(:id).where(:ingredient_type_id => id).count > 0
        false
      end

      def self.default_type
        self.where(:color_code => 'default').first
      end

      private

      def after_commit
        super
        update_shopping_list_items
      end

      def update_shopping_list_items
        affected = MTMD::FamilyCookBook::ShoppingListItem.where(:shopping_order => id.to_s).all

        affected.each do |item|
          item.update(:color_code => color_code)
        end
      end

    end
  end
end
