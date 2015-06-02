MTMD::FamilyCookBook::Tag.all.each do |tag|
  tag.destroy
end


MTMD::FamilyCookBook::IngredientQuantity.all.each do |ingredient_quantity|
  ingredient_quantity.destroy
end

MTMD::FamilyCookBook::Unit.all.each do |unit|
  unit.destroy
end

MTMD::FamilyCookBook::Recipe.all.each do |recipe|
  recipe.destroy
end

MTMD::FamilyCookBook::Ingredient.all.each do |ingredient|
  ingredient.destroy
end

####################################################
recipe = MTMD::FamilyCookBook::Recipe.new(
  :title                => 'Some vegetarian recipe',
  :description          => 'Echt schwarz stark und lecker',
  :type                 => 'MTMD::FamilyCookBook::RecipeVegetarian',
  :difficulty           => 4,
  :duration_cooking     => 45,
  :duration_preparation => 45,
  :cookware_amount      => 2,
  :tips_and_tricks      => 'Tips and tricks'
).save


####################################################
tofu = MTMD::FamilyCookBook::Ingredient.new(
  :title       => 'Tofu',
  :description => 'Olé'
).save
recipe.add_ingredient(tofu)

erdnuesse = MTMD::FamilyCookBook::Ingredient.new(
  :title       => 'Erdnüsse',
  :description => 'Oh yes'
).save
recipe.add_ingredient(erdnuesse)

wildreis = MTMD::FamilyCookBook::Ingredient.new(
  :title       => 'Wildreis',
  :description => 'Oh lala'
).save
recipe.add_ingredient(wildreis)

puts "Amount of ingredients: #{recipe.ingredients.size}"


####################################################
grams = MTMD::FamilyCookBook::Unit.new(
  :name        => 'Gramm',
  :short_name  => 'g',
  :description => 'Nothing alter'
).save

pieces = MTMD::FamilyCookBook::Unit.new(
    :name        => 'Stück',
    :short_name  => 'St.',
    :description => 'Nothing alter'
).save

puts "Amount of units: #{MTMD::FamilyCookBook::Unit.count}"


####################################################
ingredient_quantitiy = MTMD::FamilyCookBook::IngredientQuantity.new(
  :amount        => 200,
  :portions      => 4,
  :description   => 'Irgendein schlauer Kommentar',
  :unit_id       => grams.id,
  :ingredient_id => tofu.id,
  :recipe_id     => recipe.id
).save
ingredient_quantitiy.add_recipe(recipe)
ingredient_quantitiy.add_ingredient(tofu)
ingredient_quantitiy.add_unit(grams)

puts "Amount of ingredient quantities: #{recipe.ingredient_quantities.size}"


####################################################
tag = MTMD::FamilyCookBook::Tag.new(
  :name        => 'Hülsenfrüchte',
  :description => 'Gerichte mit Hülsenfrüchten'
).save
recipe.add_tag(tag)

tag = MTMD::FamilyCookBook::Tag.new(
  :name        => 'Tofu',
  :description => 'Gerichte mit Tofu'
).save
recipe.add_tag(tag)

puts "Amount of tags: #{recipe.tags.size}"
####################################################
