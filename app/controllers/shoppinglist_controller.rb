MTMD::FamilyCookBook::App.controllers :shoppinglist do

  before do
    @logic_class = MTMD::FamilyCookBook::ShoppingListActions.new(params)
  end

  get :index  do
    @items = @logic_class.items
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
    @shopping_list  = @logic_class.new
    render 'shoppinglist/new'
  end

  get :create_from_menu, :with => :menu_id do
    @shopping_list  = @logic_class.create_from_menu
    unless @shopping_list
      flash[:error] = "Please provide a valid menu id!"
      redirect_to url(:shoppinglist, :index)
    end
    render 'shoppinglist/show'
  end
end
