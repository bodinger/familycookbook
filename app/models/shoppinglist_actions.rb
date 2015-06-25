module MTMD
  module FamilyCookBook
    class ShoppingListActions
      include MTMD::FamilyCookBook::SharedActions
      include MTMD::FamilyCookBook::ApplicationHelper

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

      def shoppinglist(menu)

        #@recipe.ingredient_quantities.sort_by { |a| a.ingredients.first.title.downcase }

        ingredient_quantities = []
        #aggregated = []
        menu.menu_items_dataset.where(:shopping_list => true).all.each do |menu_item|
          menu_item.recipes_dataset.all.each do |recipe|
            recipe.ingredient_quantities_dataset.all.each do |ingredient_quantity|
              ingredient_quantities << ingredient_quantity
              #puts "MENU ITEM: #{menu_item.id} / RECIPE ID: #{recipe.id} / ID: #{ingredient_quantity.id} / INGREDIENT: #{ingredient_quantity.ingredient_id} / AMOUNT: #{ingredient_quantity.amount}"
              # aggregation_key = "#{menu_item.id}-#{recipe.id}-#{ingredient_quantity.ingredient_id}-#{ingredient_quantity.unit_id}-#{ingredient_quantity.amount}"
              # unless aggregated.fetch(ingredient_quantity.ingredient_id)
              #   puts "new key"
              #   aggregated["ing-#{ingredient_quantity.ingredient_id.to_s}"] = []
              # end
              # aggregated["ing-#{ingredient_quantity.ingredient_id.to_s}"] << ingredient_quantity.id
            end
          end
        end

        puts "TOTAL AMOUNT FOR SHOPPING LIST #{ingredient_quantities.size}"

        #puts aggregated.inspect
      end
    end
  end
end
