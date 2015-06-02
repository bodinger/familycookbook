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

      plugin :association_dependencies,
             :tags                  => :nullify,
             :ingredients           => :nullify,
             :ingredient_quantities => :nullify

    end
  end
end
