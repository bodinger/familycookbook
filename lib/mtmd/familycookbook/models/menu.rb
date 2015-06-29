module MTMD
  module FamilyCookBook
    class Menu < Sequel::Model(:menus)
      DEFAULT_DATE_RANGE_PERIOD = 1.days

      plugin :timestamps, :update_on_create => true

      many_to_many :menu_items,
                   :class      => 'MTMD::FamilyCookBook::MenuItem',
                   :join_table => :menu_items_menus,
                   :left_key   => :menu_id,
                   :right_key  => :menu_items_id

      plugin :association_dependencies,
             :menu_items => :nullify

      def range_begin
        date_range.begin.strftime('%d.%m.%Y') if date_range.begin
      end

      def range_end
        date_range.end.strftime('%d.%m.%Y') if date_range.begin
      end

      def range_days
        if date_range.blank? || date_range.begin.blank? || date_range.end.blank?
          return DateTime.now.to_date..(DateTime.now+DEFAULT_DATE_RANGE_PERIOD).to_date
        end
        date_range.begin.to_date..date_range.end.to_date
      end

      def menu_items_for_day(date)
        return if new?
        menu_items_dataset.
          where('day >= ?', date).
          where('day <= ?', date+1).
          order(:slot_order)
      end

      def menu_items_for_day_and_slot(date, slot_id)
        query = menu_items_dataset.
          where('day >= ?', date).
          where('day <= ?', date+1).
          where(:slot_order => slot_id)
        query.all
      end

      def before_update
        cleanup_menu_items
        super
      end

      def cleanup_menu_items
        old_daterange = Menu[self.id][:date_range]
        new_daterange = date_range
        (old_daterange.begin.to_date..old_daterange.end.to_date).each do |day|
          next if new_daterange.include?(day)
          invalid_menu_items = menu_items_for_day(day).all
          invalid_menu_items.each do |menu_item|
            menu_item.destroy
          end
        end
      end
    end
  end
end
