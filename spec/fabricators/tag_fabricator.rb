Fabricator(:ingredient_type, :class_name => '::MTMD::FamilyCookBook::IngredientType') do
  name        { Faker::Internet.name }
  description { Faker::Lorem.sentence }
end
