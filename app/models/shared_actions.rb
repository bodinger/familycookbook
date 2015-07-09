module MTMD
  module FamilyCookBook
    module SharedActions

      def check_shopping_list_id(key)
        shoppinglist_id = @params.fetch(key, nil)
        if shoppinglist_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::ShoppingList[shoppinglist_id]
      end

      def check_ingredient_id(key)
        ingredient_id = @params.fetch(key, nil)
        if ingredient_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Ingredient[ingredient_id]
      end

      def check_unit_id(key)
        unit_id = @params.fetch(key, nil)
        if unit_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Unit[unit_id]
      end

    end
  end
end
