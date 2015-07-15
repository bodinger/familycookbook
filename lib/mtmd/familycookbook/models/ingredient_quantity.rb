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
        puts "-----------------------------"
        puts __method__
        puts "-----------------------------"
        return if recipe_id.blank? || ingredient_id.blank?
        puts "INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE "
        puts __method__
        puts "INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE "
        Recipe[recipe_id].add_ingredient(Ingredient[ingredient_id])
      end

      def remove_dependant_associations
        puts "-----------------------------"
        puts __method__
        puts "-----------------------------"
        puts "INGREDIENT_ID:        #{ingredient_id}"
        puts "INGREDIENT_ID (this): #{this.ingredient_id}"
        raise "DEBUGIGNG"
        return if id.blank? || recipe_id.blank? || ingredient_id.blank?
        puts "INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE "
        puts "INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE INSIDE "
        Recipe[recipe_id].remove_ingredient(Ingredient[ingredient_id])
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
