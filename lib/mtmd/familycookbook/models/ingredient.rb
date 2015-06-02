module MTMD
  module FamilyCookBook
    class Ingredient < Sequel::Model(:ingredients)
      plugin :timestamps, :update_on_create => true

      many_to_many :recipes,
                   :class => 'MTMD::FamilyCookBook::Recipe',
                   :join_table => :ingredients_recipes,
                   :left_key => :ingredient_id,
                   :right_key => :recipe_id

      many_to_many :ingredient_quantities,
                   :class => 'MTMD::FamilyCookBook::IngredientQuantity',
                   :join_table => :ingredient_quantities_ingredients,
                   :left_key => :ingredient_id,
                   :right_key => :ingredient_quantities_id

      plugin :association_dependencies,
             :recipes               => :nullify,
             :ingredient_quantities => :nullify

    end
  end
end
