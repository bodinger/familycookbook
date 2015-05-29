MTMD::FamilyCookBook::App.controllers :recipe do

  get :show, :with => '(:id)' do
    recipe_id = params.fetch('id', nil)
    check_recipe_id(recipe_id)

    @recipe = MTMD::FamilyCookBook::Recipe[recipe_id]
    if @recipe.nil?
      flash[:error] = "No recipe with that id found!"
      redirect_to url(:recipe, :index)
    end

    render 'show'
  end

  get :index  do
    @items = MTMD::FamilyCookBook::Recipe.all

    render 'recipe/index'
  end

  get :new do
    @recipe = MTMD::FamilyCookBook::Recipe.new
    render 'recipe/new'
  end

  post :create do
    puts params.keys.first.inspect
    puts params.keys.first.constantize
    puts params.inspect
    render 'shared/not_implemented'
  end

  get :edit, :with => '(:id)' do
    recipe_id = params.fetch('id', nil)
    check_recipe_id(recipe_id)

    @recipe = MTMD::FamilyCookBook::Recipe[recipe_id]
    if @recipe.nil?
      flash[:error] = "No recipe with that id found!"
      redirect_to url(:recipe, :index)
    end

    render 'recipe/edit'
  end

  delete :destroy, :with => :id do
    render 'shared/not_implemented'
  end

  put :update, :with => :id do
    render 'shared/not_implemented'
  end

  post :add_ingredient_and_amount, :with => :id do
    render 'shared/not_implemented'
  end

  delete :remove_ingredient, :with => :id do
    render 'shared/not_implemented'
  end

end
