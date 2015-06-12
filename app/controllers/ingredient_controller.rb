MTMD::FamilyCookBook::App.controllers :ingredient do

  before do
    @logic_class = MTMD::FamilyCookBook::IngredientActions.new(params)
  end

  get :show, :with => '(:id)' do
    @ingredient = @logic_class.check_id

    unless @ingredient
      flash[:error] = "Please provide a valid ingredient id!"
      redirect_to url(:ingredient, :index)
    end

    render 'show'
  end

  get :index  do
    @items = @logic_class.ingredients
    render 'ingredient/index'
  end

  get :new do
    @ingredient = @logic_class.new
    render 'ingredient/new'
  end

  post :create do
    ingredient = @logic_class.create

    unless ingredient
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Ingredient has been created."
    end

    redirect_to url(:ingredient, :index)
  end

  get :edit, :with => '(:id)' do
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
    redirect_to url(:ingredient, :show, ingredient.id)
  end

end
