MTMD::FamilyCookBook::Recipe.all.each do |recipe|
  recipe.destroy
end
MTMD::FamilyCookBook::Ingredient.all.each do |ingredient|
  ingredient.destroy
end


recipe = MTMD::FamilyCookBook::Recipe.new(
  :title       => 'Some recipe',
  :description => 'Echt schwarz stark und lecker'
).save

3.times do
  ingredient = MTMD::FamilyCookBook::Ingredient.new(
    :title       => 'Some ingredient',
    :description => 'Komisches Zeuch'
  ).save
  recipe.add_ingredient(ingredient)
end

puts "Amount of ingredients: #{recipe.ingredients.size}"
