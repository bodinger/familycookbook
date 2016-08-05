Fabricator(:ingredient_type, :class_name => '::MTMD::FamilyCookBook::IngredientType') do
  name        { Faker::Internet.name }
  short_name  { Faker::Lorem.words.first.downcase }
  description { Faker::Lorem.sentence }
end
