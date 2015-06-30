module MTMD
  module FamilyCookBook
    class ShoppingListActions
      include MTMD::FamilyCookBook::SharedActions
      #include MTMD::FamilyCookBook::ApplicationHelper

      def initialize(params)
        @params = params
      end

      def check_id
        menu_id = @params.fetch('id', nil)
        if menu_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Menu[menu_id]
      end

      def menus
        MTMD::FamilyCookBook::Menu.order(Sequel.function(:lower, :date_range)).all
      end

      def new
        MTMD::FamilyCookBook::ShoppingList.new
      end

      def shoppinglist(menu)
        items                 = []
        ingredient_quantities = ingredient_quantities_by_menu(menu)
        ingredient_ids        = ingredient_quantities.select_map(:ingredient_quantities__ingredient_id).uniq!

        ingredient_ids.each do |ingredient_id|
          ingredients = ingredient_quantities_for_ingredient(ingredient_quantities, ingredient_id)
          unit_ids    = ingredients.select_map(:ingredient_quantities__unit_id).uniq

          unit_ids.each do |unit_id|
            ingredients_by_unit = ingredient_quantities_for_unit(ingredients, unit_id)
            items << calculate_ingredient_item(ingredients_by_unit)
          end
        end
        MTMD::FamilyCookBook::ShoppingList.new(items)
      end

      def calculate_ingredient_item(dataset)
        puts dataset.first.id
        title      = MTMD::FamilyCookBook::Ingredient[dataset.first.ingredient_id].title
        unit_title = MTMD::FamilyCookBook::Unit[dataset.first.unit_id].name
        amounts    = dataset.select_map(:amount)
        amount     = 0.0
        amounts.each do |item|
          amount += item.to_f
        end
        {
          :title      => title,
          :unit_title => unit_title,
          :amount     => amount
        }
      end

      def ingredient_quantities_for_ingredient(dataset, ingredient_id)
        dataset.where(:ingredient_quantities__ingredient_id => ingredient_id)
      end

      def ingredient_quantities_for_unit(dataset, unit_id)
        dataset.where(:unit_id => unit_id, :shopping_list => true)
      end

      def ingredient_quantities_by_menu(menu)
        query = MTMD::FamilyCookBook::IngredientQuantity.
          select.
            left_join(:menu_items,          :menu_id                            => menu.id).
            left_join(:recipes,             :recipes__id                        => :menu_items__recipe_id).
            #left_join(:ingredients_recipes, :ingredients_recipes__ingredient_id => :menu_items__recipe_id).
            #left_join(:ingredients,         :ingredients__id                    => :ingredients_recipes__ingredient_id).
            where(:ingredient_quantities__recipe_id => :menu_items__recipe_id).
            order(:ingredient_id, :unit_id)
        query
      end

    end
  end
end
