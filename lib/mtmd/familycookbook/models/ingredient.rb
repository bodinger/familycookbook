module MTMD
  module FamilyCookBook
    class Ingredient < Sequel::Model(:ingredients)
      plugin :timestamps, :update_on_create => true

      many_to_many :recipes,
                   :class => 'MTMD::FamilyCookBook::Recipe',
                   :join_table => :ingredients_recipes,
                   :left_key => :ingredient_id,
                   :right_key => :recipe_id

      plugin :association_dependencies,
             :recipes => :nullify

    end
  end
end
