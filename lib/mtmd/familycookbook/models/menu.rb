module MTMD
  module FamilyCookBook
    class Menu < Sequel::Model(:menus)
      plugin :timestamps, :update_on_create => true

      many_to_many :menu_items,
                   :class      => 'MTMD::FamilyCookBook::MenuItem',
                   :join_table => :menu_items_menus,
                   :left_key   => :menu_id,
                   :right_key  => :menu_items_id

      plugin :association_dependencies,
             :menu_items => :nullify

      def range_begin
        date_range.begin.strftime('%d.%m.%Y')
      end

      def range_end
        date_range.end.strftime('%d.%m.%Y')
      end

      def range_days
        date_range.begin.to_date..date_range.end.to_date
      end

      def menu_items_for_day(date)
        menu_items_dataset.
          where('day >= ?', date).
          where('day <= ?', date+1).
          order(:slot_order).
          all
      end
    end
  end
end
