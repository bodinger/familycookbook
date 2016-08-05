Fabricator(:ingredient_type, :class_name => '::MTMD::FamilyCookBook::IngredientType') do
  title      { Faker::Internet.name }
  color_code { Faker::Lorem.words.first.downcase }
end
