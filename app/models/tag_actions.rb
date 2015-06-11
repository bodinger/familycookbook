module MTMD
  module FamilyCookBook
    class TagActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def check_id
        tag_id = @params.fetch('id', nil)
        if tag_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Tag[tag_id]
      end

      def new
        MTMD::FamilyCookBook::Tag.new
      end

      def create
        MTMD::FamilyCookBook::Tag.new(tag_params).save
      end

      def update
        tag = check_id
        return true if tag.update(tag_params)
      end

      def destroy
        destroyed_object = check_id.destroy
        !destroyed_object.exists?
      end

      def tag_options
        if @params
          return MTMD::FamilyCookBook::Tag.
            where(Sequel.like(:name, "#{@params['q']}%")).
            order(:name).
            select_map(:name)
        end
        MTMD::FamilyCookBook::Tag.
          order(:name).
          select_map(:name)
      end

      def tag_params
        @params[:mtmd_family_cook_book_tag] ||= {}.with_indifferent_access
      end

      def tags
        MTMD::FamilyCookBook::Tag.all
      end

    end
  end
end
