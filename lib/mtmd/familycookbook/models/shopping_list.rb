module MTMD
  module FamilyCookBook
    class ShoppingList < Sequel::Model(:shopping_lists)
      plugin :timestamps, :update_on_create => true

      one_to_many :shopping_list_items,
                  :class       => 'MTMD::FamilyCookBook::ShoppingListItem',
                  :key         => :id,
                  :primary_key => :shopping_list_item_id

    end
  end
end
