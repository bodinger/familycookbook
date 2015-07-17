module MTMD
  module FamilyCookBook
    class RecipeActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def new
        MTMD::FamilyCookBook::Recipe.new
      end

      def create
        MTMD::FamilyCookBook::Recipe.new(recipe_params).save
      end

      def update
        recipe = check_recipe_id('id')
        return true if recipe.update(recipe_params)
      end

      def update_single(ingredient_quantity, ingredient, unit)
        return true if ingredient_quantity.
          update(
            :ingredient_id => ingredient.id,
            :unit_id       => unit.id,
            :portions      => @params.fetch('portions', nil),
            :amount        => @params.fetch('amount', nil),
            :description   => @params.fetch('description', nil)
          )
      end

      def destroy
        recipe = check_recipe_id('id')
        MTMD::FamilyCookBook::IngredientQuantity.where(:recipe_id => recipe.id).destroy
        MTMD::FamilyCookBook::MenuItem.where(:recipe_id => recipe.id).destroy
        destroyed_object = recipe.destroy
        !destroyed_object.exists?
      end

      def recipe_params
        @params[:mtmd_family_cook_book_recipe] ||= {}.with_indifferent_access
      end

      def recipes
        MTMD::FamilyCookBook::Recipe.order(:title).all
      end

      def add_amount_and_ingredient
        ingredient_id = process_ingredient
        unit_id       = process_unit

        ingredient_quantity = MTMD::FamilyCookBook::IngredientQuantity.new(
          :amount        => @params.fetch('amount', nil),
          :portions      => @params.fetch('portions', nil),
          :description   => @params.fetch('description', nil),
          :ingredient_id => ingredient_id,
          :unit_id       => unit_id,
          :recipe_id     => @params.fetch('id', nil)
        ).save
      end

      def process_ingredient
        ingredient_raw = @params.fetch('ingredient_id', nil)
        return if ingredient_raw.blank?
        return add_ingredient(ingredient_raw) if ingredient_raw.to_i == 0
        return ingredient_raw.to_i
      end

      def process_unit
        unit_raw = @params.fetch('unit_id', nil)
        return if unit_raw.blank?
        return add_unit(unit_raw) if unit_raw.to_i == 0
        return unit_raw.to_i
      end

      def remove_amount_and_ingredient
        destroyed_object = check_ingredient_quantity_id('ingredient_quantity_id').destroy
        !destroyed_object.exists?
      end

      def add_tag
        tag_name = @params.fetch('tag_name', nil)
        return unless tag_name
        tag = MTMD::FamilyCookBook::Tag.find_or_new(:name => tag_name)
        recipe = check_recipe_id('id')
        recipe.add_tag(tag)
        return tag
      end

      def remove_tag
        tag = check_tag_id('tag_id')
        recipe = check_recipe_id('id')
        recipe.remove_tag(tag)
      end

      def recipe_options
        query = MTMD::FamilyCookBook::Recipe.
          select(:id, :title___text).
          order(:title)
        if @params && @params['q']
          query_string = @params['q']
          return query if query_string.blank?
          return query.
            where(Sequel.ilike(:title, "#{query_string}%"))
        end
        query
      end

    end
  end
end
