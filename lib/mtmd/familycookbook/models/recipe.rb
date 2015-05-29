module MTMD
  module FamilyCookBook
    class Recipe < Sequel::Model(:recipes)
      plugin :timestamps, :update_on_create => true

      many_to_many :ingredients,
                   :class => 'MTMD::FamilyCookBook::Ingredient',
                   :join_table => :ingredients_recipes,
                   :left_key => :recipe_id,
                   :right_key => :ingredient_id


      plugin :association_dependencies,
             :ingredients => :nullify

    end
  end
end
