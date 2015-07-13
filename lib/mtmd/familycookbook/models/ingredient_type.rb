module MTMD
  module FamilyCookBook
    class IngredientType < Sequel::Model(:ingredient_types)
      plugin :timestamps, :update_on_create => true

    end
  end
end
