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

      def check_ingredient_quantity_id
        ingredient_quantity_id = @params.fetch('ingredient_quantity_id', nil)
        if ingredient_quantity_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::IngredientQuantity[ingredient_quantity_id]
      end

      def check_unit_id
        unit_id = @params.fetch('unit_id', nil)
        if unit_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Unit[unit_id]
      end

      def check_tag_id
        tag_id = @params.fetch('tag_id', nil)
        if tag_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Tag[tag_id]
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
        recipe = check_id
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
        ingredient_quantity = MTMD::FamilyCookBook::IngredientQuantity.new(
          :amount        => @params.fetch('amount', nil),
          :portions      => @params.fetch('portions', nil),
          :description   => @params.fetch('description', nil),
          :unit_id       => @params.fetch('unit_id', nil),
          :ingredient_id => @params.fetch('ingredient_id', nil),
          :recipe_id     => @params.fetch('id', nil)
        ).save
        ingredient_quantity.add_recipe(MTMD::FamilyCookBook::Recipe[ingredient_quantity.recipe_id])
        ingredient_quantity.add_ingredient(MTMD::FamilyCookBook::Ingredient[ingredient_quantity.ingredient_id])
        ingredient_quantity.add_unit(MTMD::FamilyCookBook::Unit[ingredient_quantity.unit_id])
      end

      def remove_amount_and_ingredient
        destroyed_object = check_ingredient_quantity_id.destroy
        !destroyed_object.exists?
      end

      def add_tag
        tag_name = @params.fetch('tag_name', nil)
        return unless tag_name
        tag = MTMD::FamilyCookBook::Tag.find_or_new(:name => tag_name)
        recipe = check_id
        recipe.add_tag(tag)
        return tag
      end

      def remove_tag
        tag = check_tag_id
        recipe = check_id
        recipe.remove_tag(tag)
      end

      def recipe_options
        if @params
          query_string = @params['q']
          return if query_string.blank?
          return MTMD::FamilyCookBook::Recipe.
            select(:id, :title___text).
            where(Sequel.ilike(:title, "#{query_string}%")).
            order(:title)
        end
        MTMD::FamilyCookBook::Recipe.
          select(:id, :title___text).
          order(:title)
      end

    end
  end
end
