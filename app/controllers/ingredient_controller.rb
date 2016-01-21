MTMD::FamilyCookBook::App.controllers :ingredient do

  before do
    @logic_class = MTMD::FamilyCookBook::IngredientActions.new(params)
  end

  get :as_array, :with => '(:q)' do
    content_type 'application/json;charset=utf8'

    @logic_class.ingredient_options.to_json
  end

  get :as_array_with_string_values, :with => '(:q)' do
    content_type 'application/json;charset=utf8'

    @logic_class.ingredient_string_options.to_json
  end

  get :index, :with => '(:page, :limit)'  do
    @pagination = pagination_from_params(@logic_class.params)
    @items      = @logic_class.ingredients(@pagination)

    render 'ingredient/index'
  end

  get :new do
    @ingredient = @logic_class.new
    render 'ingredient/new'
  end

  post :create do
    if @logic_class.ingredient_params[:title].blank?
      flash[:error] = "Please provide a valid title!"
      redirect_to url(:ingredient, :new)
      return
    end

    ingredient = @logic_class.create

    unless ingredient
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Ingredient has been created."
    end

    redirect_to url(:ingredient, :index)
  end

  get :edit, :with => '(:id)' do
    @tabindex   = @logic_class.tabindex
    @ingredient = @logic_class.check_id

    unless @ingredient
      flash[:error] = "Please provide a valid ingredient id!"
      redirect_to url(:ingredient, :index)
    end

    render 'ingredient/edit'
  end

  delete :destroy, :with => :id do
    ingredient = @logic_class.check_id

    unless ingredient
      flash[:error] = "Please provide a valid ingredient id!"
      redirect_to url(:ingredient, :index)
    end

    if ingredient.used_in_recipes.any?
      flash[:error] = "The ingredient is still used in recipes! Please remove the references first!"
      redirect_to url(:ingredient, :index)
    end

    if ingredient.used_in_shopping_lists.any?
      flash[:error] = "The ingredient is still used in shopping lists! Please remove the references first!"
      redirect_to url(:ingredient, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Ingredient has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:ingredient, :index)
  end

  put :update, :with => :id do
    ingredient = @logic_class.check_id
    unless ingredient
      flash[:error] = "Please provide a valid ingredient id!"
      redirect_to url(:ingredient, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Ingredient has been save successfully."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:ingredient, :index)
  end

end
