module MTMD
  module FamilyCookBook
    class IngredientTypeActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def check_id
        ingredient_type_id = @params.fetch('id', nil)
        if ingredient_type_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::IngredientType[ingredient_type_id]
      end

      def new
        MTMD::FamilyCookBook::IngredientType.new
      end

      def create
        item_params = ingredient_type_params
        item_params[:color_code] = 'default' if item_params[:color_code].blank?
        MTMD::FamilyCookBook::IngredientType.new(item_params).save
      end

      def update
        ingredient_type = check_id
        return true if ingredient_type.update(ingredient_type_params)
      end

      def destroy
        destroyed_object = check_id.destroy
        !destroyed_object.exists?
      end

      def ingredient_type_params
        @params[:mtmd_family_cook_book_ingredient_type] ||= {}.with_indifferent_access
      end

      def ingredients
        MTMD::FamilyCookBook::IngredientType.order(:title).all
      end

      def ingredient_type_options
        query = MTMD::FamilyCookBook::IngredientType.
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
