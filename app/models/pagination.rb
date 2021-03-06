module MTMD
  module FamilyCookBook
    class Pagination
      PAGE_SIZE    = 20
      PAGE_NUMBER  = 1

      attr_reader :page_size,
                  :page_number

      attr_accessor :errors_array,
                    :total

      def initialize(options = {})
        options       = options.symbolize_keys
        @errors_array = []
        @total        = options.fetch(:total, nil)
        @page_size    = options.fetch(:limit, PAGE_SIZE).to_i
        @page_number  = options.fetch(:page, PAGE_NUMBER).to_i
      end

      def valid?
        if page_size.to_i > PAGE_SIZE
          errors_array << "Page can have only #{PAGE_SIZE} items."
          return false
        end

        true
      end

      def previous
        return nil if page_number == 1
        page_number-1
      end

      def next
        page_number+1
      end

      def last
        return nil unless total
        total_pages
      end

      def first
        1
      end

      def offset
        return 0 if page_number == 1
        page_number * page_size
      end

      def limit
        page_size
      end

      def errors
        errors_array
      end

      def total_pages
        value = total.to_f / page_size.to_f
        return value.ceil if value < 1.0
        value.to_i
      end

    end

  end
end
