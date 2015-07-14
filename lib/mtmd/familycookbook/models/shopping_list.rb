module MTMD
  module FamilyCookBook
    class ShoppingList < Sequel::Model(:shopping_lists)
      plugin :timestamps, :update_on_create => true

      one_to_many :shopping_list_items,
                  :class       => 'MTMD::FamilyCookBook::ShoppingListItem',
                  :key         => :id,
                  :primary_key => :shopping_list_item_id

      def shopping_list_items
        MTMD::FamilyCookBook::ShoppingListItem.where(:shopping_list_id => id)
      end

      def single_shopping_list
        all_items = shopping_list_items.all
        items = []
        all_items.each do |item|
          list_item = MTMD::FamilyCookBook::AggregatedShoppingListItem.new(
            item.ingredient_id,
            item.unit_id,
            item.amount,
            item.active,
            item.color_code
          )
          list_item.id = item.id
          items << list_item
        end
        items
      end

      def aggregated_shopping_list
        items = []
        ingredients_units_tupel.each do |tupel|
          tupel_result = items_by_ingredient_and_unit(tupel.ingredient_id, tupel.unit_id)
          amount = add_up(tupel_result)
          items << MTMD::FamilyCookBook::AggregatedShoppingListItem.new(
            tupel.ingredient_id,
            tupel.unit_id,
            amount,
            tupel.active,
            tupel.color_code
          )
        end
        items
      end

      def add_up(tupel_result)
        total = 0.to_f
        tupel_result.each do |item|
          total += item.amount.to_f
        end
        total
      end

      def items_by_ingredient_and_unit(ingredient_id, unit_id)
        MTMD::FamilyCookBook::ShoppingListItem.
          select(
            :id,
            :amount
          ).
          where(:ingredient_id    => ingredient_id).
          where(:unit_id          => unit_id).
          where(:shopping_list_id => id).
          order(:shopping_order).
          all
      end

      def ingredients_units_tupel
        MTMD::FamilyCookBook::ShoppingListItem.
          distinct.
          select(:ingredient_id, :unit_id, :active, :shopping_order, :color_code).
          where(:shopping_list_id => id).
          group(:ingredient_id, :unit_id, :active, :shopping_order, :color_code).
          order(:shopping_order).
          all
      end

    end
  end
end
