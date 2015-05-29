# Helper methods defined here can be accessed in any controller or view in the application

module MTMD
  module FamilyCookBook
    module ModelsHelper

      def ingredients_options
        MTMD::FamilyCookBook::Ingredient.
          order(:title).
          select_map([:title, :id])
      end
    end
  end
end

MTMD::FamilyCookBook::App.helpers MTMD::FamilyCookBook::ModelsHelper
