module MTMD
  module FamilyCookBook
    class IngredientActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def check_id
        ingredient_id = @params.fetch('id', nil)
        if ingredient_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Ingredient[ingredient_id]
      end

      def new
        MTMD::FamilyCookBook::Ingredient.new
      end

      def create
        MTMD::FamilyCookBook::Ingredient.new(ingredient_params).save
      end

      def update
        ingredient = check_id
        return true if ingredient.update(ingredient_params)
      end

      def destroy
        destroyed_object = check_id.destroy
        !destroyed_object.exists?
      end

      def ingredient_params
        @params[:mtmd_family_cook_book_ingredient] ||= {}.with_indifferent_access
      end

      def ingredients
        MTMD::FamilyCookBook::Ingredient.all
      end

    end
  end
end
