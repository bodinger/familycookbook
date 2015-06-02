module MTMD
  module FamilyCookBook
    class Tag < Sequel::Model(:tags)
      plugin :timestamps, :update_on_create => true

      many_to_many :recipes,
                   :class     => 'MTMD::FamilyCookBook::Recipe',
                   :left_key  => :tag_id,
                   :right_key => :recipe_id

      plugin :association_dependencies,
             :recipes => :nullify

    end
  end
end
