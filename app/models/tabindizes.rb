module MTMD
  module FamilyCookBook
    class Tabindices
      MAX_TABINDEX = 10000

      attr_accessor :tabindex,
                    :max_tabindex

      def initialize(value = 10)
        @tabindex     = value
        @max_tabindex = MAX_TABINDEX
      end

      def next
        @tabindex = @tabindex + 1
        @tabindex
      end

      def next_reverse
        @max_tabindex = @max_tabindex - 1
        @max_tabindex
      end
    end
  end
end
