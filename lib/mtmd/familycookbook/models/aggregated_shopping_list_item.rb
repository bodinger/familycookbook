module MTMD
  module FamilyCookBook
    class AggregatedShoppingListItem

      attr_reader :id,
                  :ingredient_id,
                  :ingredient_name,
                  :unit_id,
                  :unit_title,
                  :active,
                  :type,
                  :amount

      def initialize(ingredient_id, unit_id, amount, active)
        @ingredient_id   = ingredient_id
        @ingredient_name = Ingredient[ingredient_id].title
        @unit_id         = unit_id
        @unit_title      = Unit[unit_id].name
        @active          = active
        @amount          = amount
      end

      def id=(id)
        @id = id
      end

    end
  end
end
