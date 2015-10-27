module MTMD
  module FamilyCookBook
    class Pagination
      PAGE_SIZE    = 25
      PAGE_NUMBER  = 1

      attr_reader :page_size,
                  :page_number

      attr_accessor :errors_array

      def initialize(options = {})
        @errors_array = []
        @page_size    = options.fetch(:page, PAGE_SIZE)
        @page_number  = options.fetch(:limit, PAGE_NUMBER)
      end

      def valid?
        if page_size.to_i > PAGE_SIZE
          errors_array << "Page can have only #{PAGE_SIZE} items."
          return false
        end

        true
      end

      def errors
        errors_array
      end

    end

  end
end
