module MTMD
  module FamilyCookBook
    class RecipeActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def check_id
        recipe_id = @params.fetch('id', nil)
        if recipe_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Recipe[recipe_id]
      end

      def check_ingredient_id
        ingredient_id = @params.fetch('ingredient_id', nil)
        if ingredient_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Ingredient[ingredient_id]
      end

      def new
        MTMD::FamilyCookBook::Recipe.new
      end

      def create
        MTMD::FamilyCookBook::Recipe.new(recipe_params).save
      end

      def update
        recipe = check_id
        return true if recipe.update(recipe_params)
      end

      def destroy
        destroyed_object = check_id.destroy
        !destroyed_object.exists?
      end

      def recipe_params
        @params[:mtmd_family_cook_book_recipe] ||= {}.with_indifferent_access
      end

      def recipes
        MTMD::FamilyCookBook::Recipe.all
      end

      def add_amount_and_ingredient(recipe, ingredient)
        recipe.add_ingredient(ingredient)
        create_recipe_ingredient_amount(@params[:amount], recipe, ingredient)
      end

    end
  end
end
