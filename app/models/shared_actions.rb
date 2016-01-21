module MTMD
  module FamilyCookBook
    module SharedActions
      attr_reader :params

      def check_shopping_list_id(key)
        check_model_existence(MTMD::FamilyCookBook::ShoppingList, key)
      end

      def check_shopping_list_item_id(key)
        check_model_existence(MTMD::FamilyCookBook::ShoppingListItem, key)
      end

      def check_ingredient_id(key)
        check_model_existence(MTMD::FamilyCookBook::Ingredient, key)
      end

      def check_ingredient_quantity_id(key)
        check_model_existence(MTMD::FamilyCookBook::IngredientQuantity, key)
      end

      def check_unit_id(key)
        check_model_existence(MTMD::FamilyCookBook::Unit, key)
      end

      def check_menu_id(key)
        check_model_existence(MTMD::FamilyCookBook::Menu, key)
      end

      def check_recipe_id(key)
        check_model_existence(MTMD::FamilyCookBook::Recipe, key)
      end

      def check_tag_id(key)
        check_model_existence(MTMD::FamilyCookBook::Tag, key)
      end

      def check_model_existence(model, key)
        model_id = @params.fetch(key, nil)
        if model_id.blank?
          return nil
        end
        model[model_id]
      end

      def cast_to_bool(value)
        return true if value == true || value =~ (/^(true|t|yes|y|1)$/i)
        return false if value == false || value.blank? || value =~ (/^(false|f|no|n|0)$/i)
        raise ArgumentError.new("invalid value for Boolean: \"#{value}\"")
      end

      def add_ingredient(title)
        ingredient = MTMD::FamilyCookBook::Ingredient.new(
          :title => title,
          :ingredient_type_id => MTMD::FamilyCookBook::IngredientType.default_type[:id]
        ).save
        ingredient.id
      end

      def add_unit(name)
        unit = MTMD::FamilyCookBook::Unit.new(
            :name       => name,
            :short_name => name
        ).save
        unit.id
      end

      def add_ingredient_type(title)
        ingredient_type = MTMD::FamilyCookBook::IngredientType.new(
          :title => title
        ).save
        ingredient_type.id
      end

      def tabindex
        MTMD::FamilyCookBook::Tabindices.new
      end

    end
  end
end
