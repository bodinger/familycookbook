module MTMD
  module FamilyCookBook
    class MenuplannerActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def currentWeekStartDay

      end

      def menus
        MTMD::FamilyCookBook::Menu.order(Sequel.function(:lower, :date_range)).all
      end

      def new
        MTMD::FamilyCookBook::Menu.new
      end

    end
  end
end
