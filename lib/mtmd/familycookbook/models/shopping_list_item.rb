module MTMD
  module FamilyCookBook
    class ShoppingListItem < Sequel::Model(:shopping_list_items)
      plugin :timestamps, :update_on_create => true

      many_to_one :shopping_lists,
                  :class       => 'MTMD::FamilyCookBook::ShoppingList',
                  :key         => :id,
                  :primary_key => :shopping_list_id

      many_to_many :recipes,
                   :class      => 'MTMD::FamilyCookBook::Recipe',
                   :join_table => :recipes_shopping_list_items,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :recipe_id

      many_to_many :menu_items,
                   :class      => 'MTMD::FamilyCookBook::MenuItem',
                   :join_table => :menu_items_shopping_list_items,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :menu_item_id

      many_to_many :ingredient_quantities,
                   :class      => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :join_table => :ingredient_quantities_shopping_list_items,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :ingredient_quantity_id

      many_to_many :units,
                   :class      => 'MTMD::FamilyCookBook::Unit',
                   :join_table => :shopping_list_items_units,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :unit_id

      many_to_many :ingredients,
                   :class      => 'MTMD::FamilyCookBook::Ingredient',
                   :join_table => :ingredients_shopping_list_items,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :ingredient_id

      plugin :association_dependencies,
             :recipes               => :nullify,
             :menu_items            => :nullify,
             :ingredient_quantities => :nullify,
             :units                 => :nullify,
             :ingredients           => :nullify

      private

      def before_save
        remove_associations
        super
      end

      def after_save
        super
        add_associations
      end

      def add_associations
        unless recipe_id.blank?
          add_recipe(Recipe[recipe_id])
        end
        unless menu_item_id.blank?
          add_menu_item(MenuItem[menu_item_id])
        end
        unless ingredient_quantity_id.blank?
          add_ingredient_quantity(IngredientQuantity[ingredient_quantity_id])
        end
        unless unit_id.blank?
          add_unit(Unit[unit_id])
        end
        unless ingredient_id.blank?
          add_ingredient(Ingredient[ingredient_id])
        end
      end

      def remove_associations
        return if id.blank?
        unless recipe_id.blank?
          remove_recipe(Recipe[recipe_id])
        end
        unless menu_item_id.blank?
          remove_menu_item(MenuItem[menu_item_id])
        end
        unless ingredient_quantity_id.blank?
          remove_ingredient_quantity(IngredientQuantity[ingredient_quantity_id])
        end
        unless unit_id.blank?
          remove_unit(Unit[unit_id])
        end
        unless ingredient_id.blank?
          remove_ingredient(Ingredient[ingredient_id])
        end
      end

    end
  end
end
