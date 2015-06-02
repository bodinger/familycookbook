MTMD::FamilyCookBook::App.controllers :recipe do

  before do
    @logic_class = MTMD::FamilyCookBook::RecipeActions.new(params)
  end

  get :show, :with => '(:id)' do
    @recipe = @logic_class.check_id

    unless @recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    render 'show'
  end

  get :index  do
    @items = @logic_class.recipes
    render 'recipe/index'
  end

  get :new do
    @recipe = @logic_class.new
    render 'recipe/new'
  end

  post :create do
    recipe = @logic_class.create

    unless recipe
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Recipe has been created."
    end

    redirect_to url(:recipe, :index)
  end

  get :edit, :with => '(:id)' do
    @recipe = @logic_class.check_id

    unless @recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    render 'recipe/edit'
  end

  delete :destroy, :with => :id do
    recipe = @logic_class.check_id

    unless recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Recipe has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:recipe, :index)
  end

  put :update, :with => :id do
    recipe = @logic_class.check_id
    unless recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Recipe has been save successfully."
    else
      flash[:error] = "Nothing has been saved/changed!"
    end
    redirect_to url(:recipe, :show, recipe.id)
  end

  post :add_ingredient_and_amount, :with => :id do
    puts "===============> #{params}"

    recipe = @logic_class.check_id
    unless recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    ingredient = @logic_class.check_ingredient_id
    unless ingredient
      flash[:error] = "Please provide a valid ingredient id!"
      redirect_to url(:recipe, :edit, recipe.id)
    end

    @logic_class.add_amount_and_ingredient(recipe, ingredient)

    render 'shared/not_implemented'
  end

  delete :remove_ingredient, :with => :id do
    render 'shared/not_implemented'
  end

end
