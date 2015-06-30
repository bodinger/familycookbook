MTMD::FamilyCookBook::App.controllers :shoppinglist do

  before do
    @logic_class = MTMD::FamilyCookBook::ShoppingListActions.new(params)
  end

  get :index  do
    @items = @logic_class.menus
    render 'shoppinglist/index'
  end

  get :show, :with => '(:id)' do
    @menu  = @logic_class.check_id

    unless @menu
      flash[:error] = "Please provide a valid menu id!"
      redirect_to url(:shoppinglist, :index)
    end

    @shopping_list = @logic_class.shoppinglist(@menu)

    render 'shoppinglist/show'
  end

  get :new do
    @menu  = @logic_class.new
    render 'shoppinglist/new'
  end
end
