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

      plugin :association_dependencies,
             :ingredient_quantities => :nullify

    end
  end
end
