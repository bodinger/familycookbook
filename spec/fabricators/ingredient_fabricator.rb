Fabricator(:ingredient, :class_name => '::MTMD::FamilyCookBook::Ingredient') do
  title              { Faker::Internet.name }
  description        { Faker::Lorem.sentence }
  ingredient_type_id { Fabricate(:ingredient_type).id }
end
