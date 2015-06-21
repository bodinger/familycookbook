module MTMD
  module FamilyCookBook
    class MenuplannerActions
      DEFAULT_MENU_DAY_AMOUNT = 7

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
          :end   => (DateTime.now+DEFAULT_MENU_DAY_AMOUNT.days).strftime('%d.%m.%Y %H:%M')
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
        menu = check_id
        return true if menu.update(menu_params)
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

    end
  end
end
