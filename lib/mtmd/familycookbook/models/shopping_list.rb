module MTMD
  module FamilyCookBook
    class ShoppingList < Sequel::Model(:shopping_lists)
      plugin :timestamps, :update_on_create => true

      one_to_many :shopping_list_items,
                  :class       => 'MTMD::FamilyCookBook::ShoppingListItem',
                  :key         => :id,
                  :primary_key => :shopping_list_item_id

      def shopping_list_items
        MTMD::FamilyCookBook::ShoppingListItem.where(:shopping_list_id => id).all
      end

      def aggregated_shopping_list
        @items = []
        ingredients_units_tupel.each do |tupel|
          tupel_result = items_by_ingredient_and_unit(tupel.ingredient_id, tupel.unit_id)
          amount = add_up(tupel_result)
          @items << MTMD::FamilyCookBook::AggregatedShoppingListItem.new(
            tupel.ingredient_id,
            tupel.unit_id,
            amount,
            tupel.active
          )
        end
        @items
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
          all
      end

      def ingredients_units_tupel
        MTMD::FamilyCookBook::ShoppingListItem.
          distinct.
          select(:ingredient_id, :unit_id, :active).
          where(:shopping_list_id => id).
          group(:ingredient_id, :unit_id, :active).
          all
      end

    end
  end
end
