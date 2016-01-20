module MTMD
  module FamilyCookBook
    class IngredientType < Sequel::Model(:ingredient_types)
      plugin :timestamps, :update_on_create => true

      one_to_many :ingredients,
                  :class       => 'MTMD::FamilyCookBook::Ingredient',
                  :key         => :ingredient_type_id,
                  :primary_key => :id

      plugin :association_dependencies,
             :ingredients      => :nullify

      def has_dependant_objects?
        return true if Ingredient.select(:id).where(:ingredient_type_id => id).count > 0
        false
      end

      def self.default_type
        self.where(:color_code => 'default').first
      end

      def ingredients
        MTMD::FamilyCookBook::Ingredient.
          where(:id => ingredients_dataset.select_map(:id)).
          all
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
