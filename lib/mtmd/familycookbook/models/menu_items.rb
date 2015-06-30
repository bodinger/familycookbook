module MTMD
  module FamilyCookBook
    class MenuItem < Sequel::Model(:menu_items)
      SLOTS = %w'empty MTMD::FamilyCookBook::Slot::Breakfast MTMD::FamilyCookBook::Slot::Lunch MTMD::FamilyCookBook::Slot::Dinner'

      plugin :timestamps, :update_on_create => true

      many_to_many :menus,
                   :class     => 'MTMD::FamilyCookBook::Menu',
                   :left_key  => :menu_items_id,
                   :right_key => :menu_id

      many_to_many :recipes,
                   :class     => 'MTMD::FamilyCookBook::Recipe',
                   :left_key  => :menu_items_id,
                   :right_key => :recipe_id

      many_to_one :shopping_lists,
                  :class       => 'MTMD::FamilyCookBook::ShoppingList',
                  :key         => :id,
                  :primary_key => :menu_item_id

      plugin :association_dependencies,
             :menus          => :nullify,
             :recipes        => :nullify

      def before_save
        super
        order_slots
      end

      def order_slots
        return 0 unless SLOTS.include?(slot)
        self.slot_order = 1 if slot == 'MTMD::FamilyCookBook::Slot::Breakfast'
        self.slot_order = 2 if slot == 'MTMD::FamilyCookBook::Slot::Lunch'
        self.slot_order = 3 if slot == 'MTMD::FamilyCookBook::Slot::Dinner'
      end

    end
  end
end
