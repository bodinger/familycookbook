Fabricator(:recipe, :class_name => '::MTMD::FamilyCookBook::Recipe') do
  title                { Faker::Internet.name }
  description          { Faker::Lorem.sentence }
  tips_and_tricks      { Faker::Lorem.sentence }
  difficulty           { (1..10).to_a.sample }
  duration_cooking     { (1..60).to_a.sample }
  duration_preparation { (1..60).to_a.sample }
  cookware_amount      { (1..5).to_a.sample }
  calorie_indication   { (100..500).to_a.sample }
end
