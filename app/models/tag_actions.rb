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
        query = MTMD::FamilyCookBook::Tag.
          select(:id, :name___text).
          order(:name)
        if @params && @params['q']
          query_string = @params['q']
          return query if query_string.blank?
          return query.
            where(Sequel.ilike(:name, "%#{query_string}%"))
        end
        query
      end

      def tag_params
        @params[:mtmd_family_cook_book_tag] ||= {}.with_indifferent_access
      end

      def tags(pagination = nil)
        query = MTMD::FamilyCookBook::Tag.order(:name)
        if pagination
          pagination.total = query.count
          query = query.limit(pagination.page_size).offset(pagination.offset)
        end
        query.all
      end

    end
  end
end
