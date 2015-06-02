module MTMD
  module FamilyCookBook
    class Unit < Sequel::Model(:units)
      plugin :timestamps, :update_on_create => true

      many_to_many :ingredient_quantities,
                   :class     => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :left_key  => :unit_id,
                   :right_key => :ingredient_quantities_id

      plugin :association_dependencies,
             :ingredient_quantities => :nullify

    end
  end
end
