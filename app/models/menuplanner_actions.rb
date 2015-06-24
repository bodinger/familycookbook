module MTMD
  module FamilyCookBook
    class MenuplannerActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def range
        menu = check_id
        if menu
          return {
            :begin => DateTime.parse(menu.date_range.begin.to_s).strftime('%d.%m.%Y %H:%M'),
            :end   => DateTime.parse(menu.date_range.end.to_s).strftime('%d.%m.%Y %H:%M')
          }
        end
        return {
          :begin => DateTime.now.strftime('%d.%m.%Y %H:%M'),
          :end   => (DateTime.now+MTMD::FamilyCookBook::Menu::DEFAULT_DATE_RANGE_PERIOD).strftime('%d.%m.%Y %H:%M')
        }
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
        MTMD::FamilyCookBook::Menu.new
      end

      def create
        MTMD::FamilyCookBook::Menu.new(menu_params).save
      end

      def destroy
        destroyed_object = check_id.destroy
        !destroyed_object.exists?
      end

      def update
        menu          = check_id
        posted_params = menu_params

        process_menu_items(menu, posted_params)
        return true if menu.update(posted_params)
      end

      def process_menu_items(menu, posted_params)
        new_items_params_raw = posted_params.delete('new_item')

        new_items_params = new_items_params_raw.collect do |item|
          next unless item[1]['recipe_id']
          item[1]
        end.compact

        new_items_params.each do |menu_item_params|
          process_menu_item(menu, menu_item_params)
        end
        puts "NEW NEW NEW NEW NEW NEW NEW NEW "
        puts new_items.inspect
        puts "NEW NEW NEW NEW NEW NEW NEW NEW "
      end

      def process_menu_item(menu, menu_item_params)
        puts __method__
        puts menu
        puts menu_item_params
        puts __method__
      end

      def menu_params
        parsed_params = menu_params_raw
        range_begin   = DateTime.parse(parsed_params.delete('range_begin'))
        range_end     = DateTime.parse(parsed_params.delete('range_end'))
        parsed_params[:date_range] = range_begin..range_end
        parsed_params
      end

      def menu_params_raw
        @params[:mtmd_family_cook_book_menu] ||= {}.with_indifferent_access
      end

      def check_menu_item_id
        menu_item_id = @params.fetch('menu_item_id', nil)
        if menu_item_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::MenuItem[menu_item_id]
      end

      def check_menu_item_recipe_id
        menu_item_id = @params.fetch('menu_item_id', nil)
        recipe_id    = @params.fetch('recipe_id', nil)
        if menu_item_id.blank? || recipe_id.blank?
          return nil
        end
        result = MTMD::FamilyCookBook::MenuItem[menu_item_id].recipes_dataset.select(:id).where(:recipe_id => recipe_id)
        puts result.sql
        puts result
        result
      end

      def toggle_shopping_list(menu_item)
        return true if menu_item.update(:shopping_list => !menu_item.shopping_list)
      end

      def remove_menu_item_recipe(menu_item_id, recipe_id)

        MTMD::FamilyCookBook::MenuItem[menu_item_id].remove_recipe(MTMD::FamilyCookBook::Recipe[recipe_id])
      end

    end
  end
end
