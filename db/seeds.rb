MTMD::FamilyCookBook::MenuItem.all.each do |menu_item|
  menu_item.destroy
end

MTMD::FamilyCookBook::Menu.all.each do |menu|
  menu.destroy
end

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
breakfast = MTMD::FamilyCookBook::Recipe.new(
  :title                => 'Sweet Breakfast',
  :description          => 'Schönes normales Standardfrühstück mit Marmelade, Honig, Samba usw.',
  :type                 => 'MTMD::FamilyCookBook::RecipeSweet',
  :difficulty           => 0,
  :duration_cooking     => 5,
  :duration_preparation => 10,
  :cookware_amount      => 1,
  :calorie_indication   => 200
).save

recipe = MTMD::FamilyCookBook::Recipe.new(
  :title                => 'Some vegetarian recipe',
  :description          => 'Echt schwarz stark und lecker',
  :type                 => 'MTMD::FamilyCookBook::RecipeVegetarian',
  :difficulty           => 4,
  :duration_cooking     => 45,
  :duration_preparation => 45,
  :cookware_amount      => 2,
  :calorie_indication   => 200,
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

samba = MTMD::FamilyCookBook::Ingredient.new(
  :title       => 'Samba Nusscreme',
  :description => 'Am besten Jumbo'
).save
breakfast.add_ingredient(samba)

honey = MTMD::FamilyCookBook::Ingredient.new(
  :title       => 'Honig',
  :description => 'Lecker'
).save
breakfast.add_ingredient(honey)

marmalade = MTMD::FamilyCookBook::Ingredient.new(
  :title       => 'Marmelade',
  :description => 'Homemade Organic Strawberry with less sugar'
).save
breakfast.add_ingredient(marmalade)

puts "Amount of ingredients: #{recipe.ingredients.size}"


####################################################
grams = MTMD::FamilyCookBook::Unit.new(
  :name        => 'Gramm',
  :short_name  => 'g'
).save

pieces = MTMD::FamilyCookBook::Unit.new(
  :name        => 'Stück',
  :short_name  => 'St.'
).save

MTMD::FamilyCookBook::Unit.new(
  :name        => 'Messerspitze',
  :short_name  => 'Msp.'
).save
MTMD::FamilyCookBook::Unit.new(
  :name        => 'Teelöffel',
  :short_name  => 'TL'
).save
MTMD::FamilyCookBook::Unit.new(
  :name        => 'Esslöffel',
  :short_name  => 'EL'
).save
MTMD::FamilyCookBook::Unit.new(
  :name        => 'Kilogramm',
  :short_name  => 'kg'
).save
MTMD::FamilyCookBook::Unit.new(
  :name        => 'Tasse',
  :short_name  => 'Tasse'
).save
MTMD::FamilyCookBook::Unit.new(
  :name        => 'Milliliter',
  :short_name  => 'ml'
).save
MTMD::FamilyCookBook::Unit.new(
  :name        => 'Liter',
  :short_name  => 'l'
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

ingredient_quantitiy = MTMD::FamilyCookBook::IngredientQuantity.new(
  :amount        => 3,
  :portions      => 4,
  :description   => 'Anderer schlauer Kommentar',
  :unit_id       => pieces.id,
  :ingredient_id => wildreis.id,
  :recipe_id     => recipe.id
).save
ingredient_quantitiy.add_recipe(recipe)
ingredient_quantitiy.add_ingredient(wildreis)
ingredient_quantitiy.add_unit(pieces)

ingredient_quantitiy = MTMD::FamilyCookBook::IngredientQuantity.new(
  :amount        => 20,
  :portions      => 4,
  :description   => 'Je nach Hunger auch mehr',
  :unit_id       => grams.id,
  :ingredient_id => samba.id,
  :recipe_id     => breakfast.id
).save
ingredient_quantitiy.add_recipe(breakfast)
ingredient_quantitiy.add_ingredient(samba)
ingredient_quantitiy.add_unit(grams)

ingredient_quantitiy = MTMD::FamilyCookBook::IngredientQuantity.new(
  :amount        => 25,
  :portions      => 4,
  :description   => 'Je nach Hunger auch mehr',
  :unit_id       => grams.id,
  :ingredient_id => honey.id,
  :recipe_id     => breakfast.id
).save
ingredient_quantitiy.add_recipe(breakfast)
ingredient_quantitiy.add_ingredient(honey)
ingredient_quantitiy.add_unit(grams)

ingredient_quantitiy = MTMD::FamilyCookBook::IngredientQuantity.new(
  :amount        => 35,
  :portions      => 4,
  :description   => 'Je nach Hunger auch mehr',
  :unit_id       => grams.id,
  :ingredient_id => marmalade.id,
  :recipe_id     => breakfast.id
).save
ingredient_quantitiy.add_recipe(breakfast)
ingredient_quantitiy.add_ingredient(marmalade)
ingredient_quantitiy.add_unit(grams)

puts "Amount of ingredient quantities: #{MTMD::FamilyCookBook::IngredientQuantity.count}"


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

MTMD::FamilyCookBook::Tag.new(
  :name        => 'Seitan',
  :description => 'Gerichte mit Seitan'
).save
MTMD::FamilyCookBook::Tag.new(
  :name        => 'Reis',
  :description => 'Gerichte mit Reis'
).save
MTMD::FamilyCookBook::Tag.new(
  :name        => 'Kohlenhydrate',
  :description => 'Gerichte mit Kohlenhydraten'
).save
MTMD::FamilyCookBook::Tag.new(
  :name        => 'Eiweiß',
  :description => 'Gerichte mit Eiweiß'
).save
MTMD::FamilyCookBook::Tag.new(
  :name        => 'Sommerlich',
  :description => 'Sommerliche Gerichte'
).save
MTMD::FamilyCookBook::Tag.new(
  :name        => 'Suppe',
  :description => 'Suppen'
).save

tag = MTMD::FamilyCookBook::Tag.new(
  :name        => 'Süß',
  :description => 'Süß'
).save
breakfast.add_tag(tag)

puts "Amount of tags: #{MTMD::FamilyCookBook::Tag.count}"


####################################################
range = DateTime.now-7.days..Time.now
menu = MTMD::FamilyCookBook::Menu.new(
    :name        => 'My first menu',
    :description => 'Some rreeeeaaaalllly nice menu description',
    :date_range  => range
).save
puts "Amount of menus: #{MTMD::FamilyCookBook::Menu.count}"


####################################################
menu_item_name = "Menu item no. "
count = 0
(range.begin.to_date..range.end.to_date).each do |day|
  count += 1
  menu_item = MTMD::FamilyCookBook::MenuItem.new(
    :title         => "#{menu_item_name} #{count} dinner slot",
    :description   => "#{menu_item_name} #{count} description dinner slot",
    :day           => Time.at(DateTime.parse(day.to_s)),
    :slot          => "MTMD::FamilyCookBook::Slot::Dinner",
    :shopping_list => true,
    :recipe_id     => recipe.id,
    :menu_id       => menu.id
  ).save
  menu.add_menu_item(menu_item)
  menu_item.add_recipe(recipe)

  menu_item = MTMD::FamilyCookBook::MenuItem.new(
    :title         => "#{menu_item_name} #{count} breakfast slot",
    :description   => "#{menu_item_name} #{count} description breakfast slot",
    :day           => Time.at(DateTime.parse(day.to_s)),
    :slot          => "MTMD::FamilyCookBook::Slot::Breakfast",
    :shopping_list => true,
    :recipe_id     => breakfast.id,
    :menu_id       => menu.id
  ).save
  menu.add_menu_item(menu_item)
  menu_item.add_recipe(breakfast)

  menu_item = MTMD::FamilyCookBook::MenuItem.new(
    :title         => "#{menu_item_name} #{count} lunch slot",
    :description   => "#{menu_item_name} #{count} description lunch slot",
    :day           => Time.at(DateTime.parse(day.to_s)),
    :slot          => "MTMD::FamilyCookBook::Slot::Lunch",
    :shopping_list => true,
    :recipe_id     => recipe.id,
    :menu_id       => menu.id
  ).save
  menu_item.order_slots
  puts "===============> #{menu_item.slot_order}"
  menu.add_menu_item(menu_item)
  menu_item.add_recipe(recipe)
end
puts "Amount of menu items: #{MTMD::FamilyCookBook::MenuItem.count}"
