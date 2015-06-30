# module MTMD
#   module FamilyCookBook
#     class ShoppingList
#       attr_reader :items
#
#       def initialize(items)
#         @items = items
#       end
#
#     end
#   end
# end
#


module MTMD
  module FamilyCookBook
    class ShoppingList < Sequel::Model(:shopping_lists)
      plugin :timestamps, :update_on_create => true

      one_to_many :menus,
                  :class       => 'MTMD::FamilyCookBook::Menu',
                  :key         => :id,
                  :primary_key => :menu_id

      one_to_many :menu_items,
                  :class       => 'MTMD::FamilyCookBook::MenuItem',
                  :left_key    => :id,
                  :primary_key => :menu_item_id

      one_to_many :ingredient_quantities,
                  :class       => 'MTMD::FamilyCookBook::IngredientQuantity',
                  :key         => :id,
                  :primary_key => :ingredient_quantity_id

      one_to_many :units,
                  :class       => 'MTMD::FamilyCookBook::Unit',
                  :key         => :id,
                  :primary_key => :unit_id

      one_to_many :ingredients,
                  :class       => 'MTMD::FamilyCookBook::Ingredient',
                  :key         => :id,
                  :primary_key => :ingredient_id

      plugin :association_dependencies,
             :menus                 => :nullify,
             :menu_items            => :nullify,
             :ingredient_quantities => :nullify,
             :units                 => :nullify

    end
  end
end
