module MTMD
  module FamilyCookBook
    module ParamsHelper

      def pagination_from_params(options = {})
        pagination = MTMD::FamilyCookBook::Pagination.new(options)
        if pagination.valid?
          pagination
        else
          halt(400, { :error => pagination.errors.first }.to_json)
        end
      end

    end

  end
end

MTMD::FamilyCookBook::App.helpers MTMD::FamilyCookBook::ParamsHelper
