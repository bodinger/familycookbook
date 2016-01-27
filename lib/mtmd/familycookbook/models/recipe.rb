module MTMD
  module FamilyCookBook
    class Recipe < Sequel::Model(:recipes)
      plugin :timestamps, :update_on_create => true

      many_to_many :ingredients,
                   :class      => 'MTMD::FamilyCookBook::Ingredient',
                   :join_table => :ingredients_recipes,
                   :left_key   => :recipe_id,
                   :right_key  => :ingredient_id

      many_to_many :ingredient_quantities,
                   :class      => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :join_table => :ingredient_quantities_recipes,
                   :left_key   => :recipe_id,
                   :right_key  => :ingredient_quantities_id

      many_to_many :tags,
                   :class      => 'MTMD::FamilyCookBook::Tag',
                   :left_key   => :recipe_id,
                   :right_key  => :tag_id

      many_to_many :menu_items,
                   :class     => 'MTMD::FamilyCookBook::MenuItem',
                   :left_key  => :recipe_id,
                   :right_key => :menu_items_id

      many_to_many :shopping_list_items,
                  :class       => 'MTMD::FamilyCookBook::ShoppingListItem',
                  :key         => :shopping_list_item_id,
                  :primary_key => :recipe_id

      plugin :association_dependencies,
             :tags                  => :nullify,
             :ingredients           => :nullify,
             :ingredient_quantities => :nullify,
             :shopping_list_items   => :nullify

      def used_in_menus
        menu_item_ids = menu_items_dataset.select_map(:menu_items_id)
        menu_ids = MTMD::FamilyCookBook::MenuItem.
          where(:id => menu_item_ids).
          distinct(:menu_id).
          select_map(:menu_id)

        MTMD::FamilyCookBook::Menu.where(:id => menu_ids).all
      end

    end
  end
end
