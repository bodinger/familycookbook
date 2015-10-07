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
        ingredient_type_id = process_ingredient_type
        ingredient_params[:ingredient_type_id] = ingredient_type_id
        MTMD::FamilyCookBook::Ingredient.new(ingredient_params).save
      end

      def process_ingredient_type
        ingredient_type_raw = ingredient_params.fetch('ingredient_type_id', nil)
        return if ingredient_type_raw.blank?
        return add_ingredient_type(ingredient_type_raw) if ingredient_type_raw.to_i == 0
        return ingredient_type_raw.to_i
      end

      def update
        ingredient = check_id
        ingredient_type_id = process_ingredient_type
        ingredient_params[:ingredient_type_id] = ingredient_type_id
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
        MTMD::FamilyCookBook::Ingredient.order(:title).all
      end

      def ingredient_options
        query = MTMD::FamilyCookBook::Ingredient.
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

      def ingredient_string_options
        query = MTMD::FamilyCookBook::Ingredient.
          select(:title___id, :title___text).
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
