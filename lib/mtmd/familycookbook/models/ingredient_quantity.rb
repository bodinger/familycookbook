module MTMD
  module FamilyCookBook
    class IngredientQuantity < Sequel::Model(:ingredient_quantities)
      plugin :timestamps, :update_on_create => true

      many_to_many :recipes,
                   :class => 'MTMD::FamilyCookBook::Recipe',
                   :left_key => :ingredient_quantities_id,
                   :right_key => :recipe_id

      many_to_many :ingredients,
                   :class => 'MTMD::FamilyCookBook::Ingredient',
                   :left_key => :ingredient_quantities_id,
                   :right_key => :ingredient_id

      many_to_many :units,
                   :class => 'MTMD::FamilyCookBook::Unit',
                   :left_key => :ingredient_quantities_id,
                   :right_key => :unit_id

      plugin :association_dependencies,
             :recipes     => :nullify,
             :ingredients => :nullify,
             :units       => :nullify

    end
  end
end
