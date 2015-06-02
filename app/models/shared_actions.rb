module MTMD
  module FamilyCookBook
    module SharedActions

      def check_amount

      end

      def create_recipe_ingredient_amount(amount, recipe, ingredient)
        MTMD::FamilyCookBook::RecipeIngredientAmount.new(
          :amount     => amount,
          :recipe     => recipe,
          :ingredient => ingredient
        )
      end

    end
  end
end
