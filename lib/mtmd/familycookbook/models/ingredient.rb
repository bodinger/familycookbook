module MTMD
  module FamilyCookBook
    class Ingredient < Sequel::Model(:ingredients)
      plugin :timestamps, :update_on_create => true

      many_to_many :recipes,
                   :class => 'MTMD::FamilyCookBook::Recipe',
                   :join_table => :ingredients_recipes,
                   :left_key => :ingredient_id,
                   :right_key => :recipe_id

      many_to_many :ingredient_quantities,
                   :class => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :join_table => :ingredient_quantities_ingredients,
                   :left_key => :ingredient_id,
                   :right_key => :ingredient_quantities_id

      many_to_one :shopping_lists,
                  :class       => 'MTMD::FamilyCookBook::ShoppingList',
                  :key         => :id,
                  :primary_key => :ingredient_id

      plugin :association_dependencies,
             :recipes               => :nullify,
             :ingredient_quantities => :nullify

      def type
        ingredient_type = MTMD::FamilyCookBook::IngredientType[ingredient_type_id]
        return unless ingredient_type
        ingredient_type.title
      end

      def used_in_recipes
        MTMD::FamilyCookBook::Recipe.
          select.
          where(:id => MTMD::FamilyCookBook::IngredientQuantity.distinct.select(:recipe_id).where(:ingredient_id => id)).
          all
      end

    end
  end
end
