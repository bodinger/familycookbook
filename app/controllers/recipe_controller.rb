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
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:recipe, :show, recipe.id)
  end

  post :add_ingredient_quantity, :with => :id do
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

    unit = @logic_class.check_unit_id
    unless unit
      flash[:error] = "Please provide a valid unit id!"
      redirect_to url(:recipe, :edit, recipe.id)
    end

    @logic_class.add_amount_and_ingredient
    redirect_to url(:recipe, :edit, recipe.id)
  end

  delete :remove_ingredient_quantity, :with => :id do
    recipe = @logic_class.check_id
    unless recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    ingredient_quantity = @logic_class.check_ingredient_quantity_id
    unless ingredient_quantity
      flash[:error] = "Please provide a valid ingredient!"
      redirect_to url(:recipe, :edit, recipe.id)
    end

    status = @logic_class.remove_amount_and_ingredient
    if status == true
      flash[:success] = "Ingredient has been removed from recipe."
    else
      flash[:error] = "An error has occurred!"
    end
    redirect_to url(:recipe, :edit, recipe.id)
  end

  post :add_tag, :with => :id do
    recipe = @logic_class.check_id
    unless recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    tag = @logic_class.add_tag
    if tag.nil?
      flash[:error] = "Invalid tag provided."
      redirect_to url(:recipe, :edit, recipe.id)
    end

    if tag.new?
      flash[:success] = "A new tag has been added."
    else
      flash[:success] = "The tag has been added."
    end

    redirect_to url(:recipe, :edit, recipe.id)
  end

  delete :remove_tag, :with => :id do
    recipe = @logic_class.check_id
    unless recipe
      flash[:error] = "Please provide a valid recipe id!"
      redirect_to url(:recipe, :index)
    end

    tag = @logic_class.check_tag_id
    unless tag
      flash[:error] = "Please provide a valid tag id!"
      redirect_to url(:recipe, :edit, recipe.id)
    end

    @logic_class.remove_tag
    flash[:success] = "The tag has been removed."

    redirect_to url(:recipe, :edit, recipe.id)
  end

end
