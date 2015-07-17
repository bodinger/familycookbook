module MTMD
  module FamilyCookBook
    class IngredientQuantity < Sequel::Model(:ingredient_quantities)
      DEFAULT_PORTIONS = 4

      plugin :timestamps, :update_on_create => true

      many_to_many :recipes,
                   :class => 'MTMD::FamilyCookBook::Recipe',
                   :left_key => :ingredient_quantities_id,
                   :right_key => :recipe_id

      many_to_many :ingredients,
                   :class => 'MTMD::FamilyCookBook::Ingredient',
                   :left_key => :ingredient_quantities_id,
                   :right_key => :ingredient_id

      many_to_many :units,
                   :class => 'MTMD::FamilyCookBook::Unit',
                   :left_key => :ingredient_quantities_id,
                   :right_key => :unit_id

      many_to_one :shopping_lists,
                  :class       => 'MTMD::FamilyCookBook::ShoppingList',
                  :key         => :id,
                  :primary_key => :ingredient_quantity_id

      plugin :association_dependencies,
             :recipes        => :nullify,
             :ingredients    => :nullify,
             :units          => :nullify

      private

      def before_save
        remove_associations
        remove_dependant_associations
        super
      end

      def before_destroy
        remove_associations
        remove_dependant_associations
        super
      end

      def after_save
        super
        add_associations
        add_dependant_associations
      end

      def add_associations
        unless recipe_id.blank?
          add_recipe(Recipe[recipe_id])
        end
        unless ingredient_id.blank?
          add_ingredient(Ingredient[ingredient_id])
        end
        unless unit_id.blank?
          add_unit(Unit[unit_id])
        end
      end

      def add_dependant_associations
        return if recipe_id.blank? || ingredient_id.blank?
        recipe = Recipe[recipe_id]

        # Don't add it if it is already existing
        existing = recipe.ingredients_dataset
        existing.each do |ingredient|
          return if ingredient.id == ingredient_id
        end

        recipe.add_ingredient(Ingredient[ingredient_id])
      end

      def remove_dependant_associations
        return if this.first.blank?
        old_ingredient_id = this.first[:ingredient_id]
        if old_ingredient_id.blank?
          old_ingredient_id = ingredient_id
        end
        return if id.blank? || recipe_id.blank?

        # Check for the same ingredient in the same recipe
        amount_of_this_for_recipe = IngredientQuantity.
          select(:ingredient_id).
          where(
            :recipe_id     => recipe_id,
            :ingredient_id => old_ingredient_id
          ).
          count

        if amount_of_this_for_recipe == 1
          Recipe[recipe_id].remove_ingredient(Ingredient[old_ingredient_id])
        end
      end

      def remove_associations
        return if id.blank?
        remove_all_ingredients
        remove_all_units
        unless recipe_id.blank?
          remove_recipe(Recipe[recipe_id])
        end
        unless ingredient_id.blank?
          remove_ingredient(Ingredient[ingredient_id])
        end
        unless unit_id.blank?
          remove_unit(Unit[unit_id])
        end
      end

    end
  end
end
