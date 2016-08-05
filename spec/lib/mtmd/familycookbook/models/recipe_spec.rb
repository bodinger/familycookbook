require 'spec_helper'

describe ::MTMD::FamilyCookBook::Recipe do
  let(:recipe_data) {
    {
      :title                => 'My Recipe title',
      :description          => 'My Recipe description',
      :tips_and_tricks      => 'My Recipe tips and tricks',
      :difficulty           => 2,
      :duration_cooking     => 30,
      :duration_preparation => 15,
      :cookware_amount      => 2,
      :calorie_indication   => 235
    }
  }

  context 'when creating a new recipe' do
    it 'persists' do
      expect { ::MTMD::FamilyCookBook::Recipe.new(recipe_data).save }.to change { ::MTMD::FamilyCookBook::Recipe.count }.by(1)
    end
  end

  context 'when editing an existing recipe' do
    let(:recipe) { Fabricate(:recipe, recipe_data) }

    context 'when updating an existing recipe' do
      before do
        recipe.update(:title => 'new title')
      end

      it 'updates something' do
        expect(recipe.title).to eq('new title')
      end
    end

    context 'when adding an ingredient_quantity' do
      let(:unit) {
        Fabricate(
          :unit,
          :name => 'Gramm'
        )
      }

      let(:ingredient_type) {
        Fabricate(
          :ingredient_type,
          :title      => 'Ingredient type',
          :color_code => 'lightblue'
        )
      }

      let(:ingredient) {
        Fabricate(
          :ingredient,
          :title              => 'MyIngredient',
          :ingredient_type_id => ingredient_type.id
        )
      }

      let(:ingredient_quantity) {
        Fabricate(
          :ingredient_quantity,
          :recipe_id     => recipe.id,
          :ingredient_id => ingredient.id,
          :unit_id       => unit.id,
          :amount        => 125,
          :portions      => 4,
          :description   => 'some additional hint'
        )
      }

      before do
        recipe.add_ingredient(ingredient)
      end

      it 'adds associations to ingredient' do
        expect(recipe.ingredients).to include(ingredient)
      end

      it 'adds associations to ingredient quantities' do
        expect(recipe.ingredients).to include(ingredient)
      end
    end
  end
end
