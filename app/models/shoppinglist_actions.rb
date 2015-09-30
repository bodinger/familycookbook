module MTMD
  module FamilyCookBook
    class ShoppingListActions
      include MTMD::FamilyCookBook::SharedActions

      TITLE_SUFFIX = ''

      def initialize(params)
        @params = params
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
        menu = check_menu_id('menu_id')
        if menu.blank?
          return nil
        end

        shopping_list = MTMD::FamilyCookBook::ShoppingList.new(
          :menu_id     => menu.id,
          :title       => menu.name,
          :description => menu.description
        ).save
        process_list(shopping_list, menu)
        shopping_list
      end

      def process_list(shopping_list, menu)
        ingredient_quantities = ingredient_quantities_by_menu(menu)

        ingredient_quantities.each do |item|
          active = true
          if item.respond_to?(:active)
            active = item.active
          end

          ingredient = Ingredient[item[:ingredient_id]]
          ingredient_type = IngredientType[ingredient.ingredient_type_id]
          color_code = nil
          color_code = ingredient_type[:color_code] unless ingredient_type.blank?

          options = {
            :shopping_list_id => shopping_list.id,
            :type             => 'automatic',
            :active           => active,
            :shopping_order   => ingredient[:ingredient_type_id] || 0,
            :color_code       => color_code
          }
          item_data = prepare_item(item, options)
          MTMD::FamilyCookBook::ShoppingListItem::new(item_data).save
        end
      end

      def prepare_item(item, opts = {})
        {
          :shopping_list_id       => opts.fetch(:shopping_list_id, 0),
          :shopping_order         => opts.fetch(:shopping_order, 0),
          :color_code             => opts.fetch(:color_code, 0),
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

      def destroy
        destroyed_object = check_shopping_list_id('id')
        MTMD::FamilyCookBook::ShoppingListItem.where(:shopping_list_id => destroyed_object.id).destroy
        destroyed_object.destroy
        !destroyed_object.exists?
      end

      def destroy_single_item
        destroyed_object = check_shopping_list_item_id('item_id')
        destroyed_object.destroy
        !destroyed_object.exists?
      end

      def update
        shopping_list = check_shopping_list_id('id')
        ingredient_id = process_ingredient
        unit_id       = process_unit
        amount        = shopping_list_params[:amount]

        return false if ingredient_id.blank? || unit_id.blank?

        ingredient      = MTMD::FamilyCookBook::Ingredient[ingredient_id]
        puts "======================="
        puts ingredient_id
        puts "======================="
        ingredient_type = MTMD::FamilyCookBook::IngredientType[ingredient.ingredient_type_id]
        if ingredient_type.nil?
          ingredient_type = MTMD::FamilyCookBook::IngredientType.where(:color_code => 'default').first
          ingredient.update(:ingredient_type_id => ingredient_type.id)
        end

        item_data = prepare_item({
            :ingredient_id => ingredient_id,
            :unit_id       => unit_id,
            :amount        => amount
          },
          {
            :shopping_list_id => shopping_list.id,
            :shopping_order   => ingredient.ingredient_type_id,
            :color_code       => ingredient_type.color_code,
            :type             => 'manual'
          }
        )

        shopping_list_item = MTMD::FamilyCookBook::ShoppingListItem::new(item_data).save
        return true if shopping_list_item.exists?
      end

      def process_ingredient
        return if shopping_list_params[:new_item].blank?
        return if shopping_list_params[:new_item][:ingredient_id].blank?
        ingredient_raw = shopping_list_params[:new_item][:ingredient_id]
        return add_ingredient(ingredient_raw) if ingredient_raw.to_i == 0
        return ingredient_raw.to_i
      end

      def process_unit
        return if shopping_list_params[:new_item].blank?
        return if shopping_list_params[:new_item][:unit_id].blank?
        unit_raw = shopping_list_params[:new_item][:unit_id]
        return add_unit(unit_raw) if unit_raw.to_i == 0
        return unit_raw.to_i
      end

      def shopping_list_params
        @params[:mtmd_family_cook_book_shopping_list] ||= {}.with_indifferent_access
      end

      def toggle_item_active(shopping_list_id, ingredient_id, unit_id)
        current = @params.fetch('current', false)
        return MTMD::FamilyCookBook::ShoppingListItem.
          where(
            :shopping_list_id => shopping_list_id,
            :ingredient_id    => ingredient_id,
            :unit_id          => unit_id
          ).
          update(
            :active => !cast_to_bool(current)
          )
      end

      def toggle_single_item_active(shopping_list_item)
        current = @params.fetch('current', false)
        return true if shopping_list_item.
          update(
            :active => !cast_to_bool(current)
          )
      end

    end
  end
end
