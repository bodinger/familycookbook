MTMD::FamilyCookBook::App.controllers :ingredient_type do

  before do
    @logic_class = MTMD::FamilyCookBook::IngredientTypeActions.new(params)
  end

  get :as_array, :with => '(:q)' do
    content_type 'application/json;charset=utf8'

    @logic_class.ingredient_type_options.to_json
  end

  get :index  do
    @items = @logic_class.ingredients
    render 'ingredient_type/index'
  end

  get :new do
    @ingredient_type = @logic_class.new
    render 'ingredient_type/new'
  end

  post :create do
    ingredient = @logic_class.create

    unless ingredient
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Ingredient type has been created."
    end

    redirect_to url(:ingredient_type, :index)
  end

  get :edit, :with => '(:id)' do
    @ingredient_type = @logic_class.check_id

    unless @ingredient_type
      flash[:error] = "Please provide a valid ingredient type!"
      redirect_to url(:ingredient_type, :index)
    end

    render 'ingredient_type/edit'
  end

  delete :destroy, :with => :id do
    ingredient = @logic_class.check_id

    unless ingredient
      flash[:error] = "Please provide a valid ingredient type!"
      redirect_to url(:ingredient_type, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Ingredient type has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:ingredient_type, :index)
  end

  put :update, :with => :id do
    ingredient = @logic_class.check_id
    unless ingredient
      flash[:error] = "Please provide a valid ingredient type!"
      redirect_to url(:ingredient_type, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Ingredient type has been save successfully."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:ingredient_type, :index)
  end

end
