module MTMD
  module FamilyCookBook
    class SearchActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params.with_indifferent_access
        @phrase = @params[:searchstring]
      end

      def results(opts = {})
        type  = opts.fetch(:type).to_s.camelize
        klass = search_klass_name(type).constantize.new
        klass.search(@phrase)
      end

      def search_klass_name(type)
        "MTMD::FamilyCookBook::Search::#{type}"
      end

      def search_params
        @params[:mtmd_family_cook_book_shopping_list] ||= {}.with_indifferent_access
      end

    end
  end
end
