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
        MTMD::FamilyCookBook::Menu.order(Sequel.function(:lower, :date_range).desc).all
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

        items_processed = process_menu_items(menu, posted_params)
        return true if menu.update(posted_params) || items_processed
      end

      def process_menu_items(menu, posted_params)
        new_items_params_raw = posted_params.delete('new_item')

        new_items_params = new_items_params_raw.collect do |item|
          next unless item[1]['recipe_id']
          item[1]
        end.compact

        items_processed = false
        new_items_params.each do |menu_item_params|
          status = process_menu_item(menu, menu_item_params)
          if status == true
            items_processed = status
          end
        end
        items_processed
      end

      def process_menu_item(menu, menu_item_params)
        menu_item = MTMD::FamilyCookBook::MenuItem.new(
          :recipe_id     => menu_item_params[:recipe_id],
          :shopping_list => menu_item_params[:shopping_list],
          :slot          => MTMD::FamilyCookBook::MenuItem::SLOTS[menu_item_params[:slot].to_i],
          :day           => Time.at(menu_item_params[:day].to_i),
          :menu_id       => menu.id
        ).save
        menu_item.add_recipe(menu_item_params[:recipe_id])
        menu_item.add_menu(menu)
        menu_item.exists?
      end

      def menu_params
        parsed_params = menu_params_raw

        range_begin_raw = parsed_params.delete('range_begin')
        range_end_raw   = parsed_params.delete('range_end')

        range_begin = DateTime.parse(range_begin_raw) unless range_begin_raw.blank?
        range_end   = DateTime.parse(range_end_raw)   unless range_end_raw.blank?

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
        menu_item = MTMD::FamilyCookBook::MenuItem[menu_item_id]
        menu_item.destroy
      end

    end
  end
end
