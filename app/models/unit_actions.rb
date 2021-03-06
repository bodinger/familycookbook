module MTMD
  module FamilyCookBook
    class UnitActions
      include MTMD::FamilyCookBook::SharedActions

      def initialize(params)
        @params = params
      end

      def check_id
        unit_id = @params.fetch('id', nil)
        if unit_id.blank?
          return nil
        end
        MTMD::FamilyCookBook::Unit[unit_id]
      end

      def new
        MTMD::FamilyCookBook::Unit.new
      end

      def create
        MTMD::FamilyCookBook::Unit.new(unit_params).save
      end

      def update
        unit = check_id
        return true if unit.update(unit_params)
      end

      def destroy
        destroyed_object = check_id.destroy
        !destroyed_object.exists?
      end

      def unit_params
        @params[:mtmd_family_cook_book_unit] ||= {}.with_indifferent_access
      end

      def units(pagination = nil)
        query = MTMD::FamilyCookBook::Unit.order(:name)
        if pagination
          pagination.total = query.count
          query = query.limit(pagination.page_size).offset(pagination.offset)
        end
        query.all
      end

      def unit_options
        query = MTMD::FamilyCookBook::Unit.
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

    end
  end
end
