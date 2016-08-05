Fabricator(:ingredient_quantity, :class_name => '::MTMD::FamilyCookBook::IngredientQuantity') do
  recipe_id     { Fabricate(:recipe).id }
  ingredient_id { Fabricate(:ingredient).id }
  unit_id       { Fabricate(:unit).id }
  amount        { (100..400).to_a.sample }
  portions      { (1..4).to_a.sample }
  description   { Faker::Lorem.sentence }
end
