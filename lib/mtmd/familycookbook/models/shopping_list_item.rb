module MTMD
  module FamilyCookBook
    class ShoppingList < Sequel::Model(:shopping_lists)
      plugin :timestamps, :update_on_create => true

      many_to_one :shopping_lists,
                  :class       => 'MTMD::FamilyCookBook::ShoppingList',
                  :key         => :id,
                  :primary_key => :shopping_list_id

      many_to_many :recipes,
                   :class      => 'MTMD::FamilyCookBook::Recipe',
                   :join_table => :shopping_list_items_recipes,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :recipe_id

      many_to_many :menu_items,
                   :class      => 'MTMD::FamilyCookBook::MenuItem',
                   :join_table => :shopping_list_items_menu_items,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :menu_item_id

      many_to_many :ingredient_quantities,
                   :class      => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :join_table => :shopping_list_items_ingredient_quantities,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :ingredient_quantity_id

      many_to_many :units,
                   :class      => 'MTMD::FamilyCookBook::Unit',
                   :join_table => :shopping_list_items_units,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :unit_id

      many_to_many :ingredients,
                   :class      => 'MTMD::FamilyCookBook::Ingredient',
                   :join_table => :shopping_list_items_ingredients,
                   :left_key   => :shopping_list_item_id,
                   :right_key  => :ingredient_id

      plugin :association_dependencies,
             :recipes               => :nullify,
             :menu_items            => :nullify,
             :ingredient_quantities => :nullify,
             :units                 => :nullify,
             :ingredients           => :nullify

    end
  end
end
