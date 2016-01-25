module MTMD
  module FamilyCookBook
    class Unit < Sequel::Model(:units)
      plugin :timestamps, :update_on_create => true

      many_to_many :ingredient_quantities,
                   :class     => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :left_key  => :unit_id,
                   :right_key => :ingredient_quantities_id

      many_to_one :shopping_lists,
                  :class       => 'MTMD::FamilyCookBook::ShoppingList',
                  :key         => :id,
                  :primary_key => :unit_id

      many_to_many :shopping_list_items,
                   :class      => 'MTMD::FamilyCookBook::ShoppingListItem',
                   :left_key   => :unit_id,
                   :right_key  => :shopping_list_item_id

      plugin :association_dependencies,
             :ingredient_quantities => :nullify

      def used_in_recipes
        MTMD::FamilyCookBook::Recipe.
          where(:id => ingredient_quantities_dataset.select(:recipe_id).distinct(:recipe_id)).
          order(:title).
          all
      end

      def used_in_shopping_lists
        MTMD::FamilyCookBook::ShoppingList.
          where(:id => shopping_list_items_dataset.select(:shopping_list_id).distinct(:shopping_list_id)).
          order(:title).
          all
      end

    end
  end
end
