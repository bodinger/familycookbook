module MTMD
  module FamilyCookBook
    class SearchModel
      def errors
        []
      end

      def self.errors
        []
      end

      def initialize(params)
        @params = params
      end

      def searchstring
        'searchstring oh yeah'
      end

      def values
        {
          :searchstring => 'second one'
        }
      end

      def id

      end

      def self.id

      end
    end
  end
end
