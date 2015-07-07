module MTMD
  module FamilyCookBook
    class ShoppingListActions
      include MTMD::FamilyCookBook::SharedActions

      TITLE_SUFFIX = 'Shopping list for menu '

      def initialize(params)
        @params = params
      end

      def check_id
        shoppinglist_id = @params.fetch('id', nil)
        if shoppinglist_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::ShoppingList[shoppinglist_id]
      end

      def check_menu_id
        menu_id = @params.fetch('menu_id', nil)
        if menu_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Menu[menu_id]
      end

      def items
        data = (
          Sequel::Model.db[:menus].
            select(
              :menus__id___id,
              :date_range,
              :name,
              :description,
              'MTMD::FamilyCookBook::Menu'.as(:type)
            ).where(
              Sequel.~(:menus__id => Sequel::Model.db[:shopping_lists].select(:menu_id).group_by(:menu_id))
            )
          ).
          union(
            Sequel::Model.db[:shopping_lists].
              select(
                :shopping_lists__id___id,
                :menus__date_range___date_range,
                :title___name,
                :shopping_lists__description,
                'MTMD::FamilyCookBook::ShoppingList'.as(:type)
              ).
              left_join(:menus, :id => :menu_id)
          ).
          order(Sequel.function(:lower, :date_range), :name).all
        data
      end

      def new
        MTMD::FamilyCookBook::ShoppingList.new
      end

      def create_from_menu
        menu = check_menu_id
        if menu.blank?
          return nil
        end

        shopping_list = MTMD::FamilyCookBook::ShoppingList.new(
          :menu_id     => menu.id,
          :title       => TITLE_SUFFIX+menu.range_begin.to_s+' '+menu.range_end.to_s+' '+menu.name,
          :description => menu.description
        ).save
        process_list(shopping_list, menu)
        shopping_list
      end

      def process_list(shopping_list, menu)
        ingredient_quantities = ingredient_quantities_by_menu(menu)

        ingredient_quantities.each do |item|
          options = {
            :shopping_list_id => shopping_list.id,
            :type             => 'automatic'
          }
          item_data = prepare_item(item, options)
          MTMD::FamilyCookBook::ShoppingListItem::new(item_data).save
        end
      end

      def prepare_item(item, opts = {})
        {
          :shopping_list_id       => opts.fetch(:shopping_list_id, 0),
          :shopping_order         => opts.fetch(:shopping_order, 0),
          :type                   => opts.fetch(:type, 'automatic'),
          :active                 => opts.fetch(:active, true),
          :recipe_id              => item[:recipe_id],
          :ingredient_id          => item[:ingredient_id],
          :ingredient_quantity_id => item[:ingredient_quantity_id],
          :unit_id                => item[:unit_id],
          :amount                 => item[:amount],
          :menu_item_id           => item[:menu_item_id]
        }
      end

      # def process_list_deprecated(shopping_list, menu)
      #   puts "???????????????"
      #   items                 = []
      #   ingredient_quantities = ingredient_quantities_by_menu(menu)
      #   ingredient_ids        = ingredient_quantities.select_map(:ingredient_quantities__ingredient_id).uniq!
      #
      #   ingredient_ids.each do |ingredient_id|
      #     ingredients = ingredient_quantities_for_ingredient(ingredient_quantities, ingredient_id)
      #     unit_ids    = ingredients.select_map(:ingredient_quantities__unit_id).uniq
      #
      #     unit_ids.each do |unit_id|
      #       ingredients_by_unit = ingredient_quantities_for_unit(ingredients, unit_id)
      #       items << calculate_ingredient_item(ingredients_by_unit)
      #     end
      #   end
      #
      #   #MTMD::FamilyCookBook::ShoppingList.new(items)
      # end

      # def calculate_ingredient_item(dataset)
      #   ingredient_id  = dataset.first.ingredient_id
      #   active         = true
      #   unit_id        = dataset.first.unit_id
      #   shopping_order = 'SomeOrder'
      #   amounts    = dataset.select_map(:amount)
      #   amount     = 0.0
      #   amounts.each do |item|
      #     amount += item.to_f
      #   end
      #   {
      #     :ingredient_id      => ingredient_id,
      #     :active => active,
      #     :unit_id     => unit_id,
      #     :shopping_order => shopping_order,
      #     :amount     => amount
      #   }
      # end
      #
      # def ingredient_quantities_for_ingredient(dataset, ingredient_id)
      #   dataset.where(:ingredient_quantities__ingredient_id => ingredient_id)
      # end
      #
      # def ingredient_quantities_for_unit(dataset, unit_id)
      #   dataset.where(:unit_id => unit_id, :shopping_list => true)
      # end

      def ingredient_quantities_by_menu(menu)
        query = Sequel::Model.db[:ingredient_quantities].
          select.
          select_more(:ingredient_quantities__id___ingredient_quantity_id).
          select_more(:menu_items__id___menu_item_id).
            left_join(:menu_items, :menu_id     => menu.id).
            left_join(:recipes,    :recipes__id => :menu_items__recipe_id).
            where(:ingredient_quantities__recipe_id => :menu_items__recipe_id).
            where(:menu_items__shopping_list => true).
            order(:ingredient_id, :unit_id)
        query
      end

    end
  end
end
