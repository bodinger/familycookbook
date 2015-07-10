MTMD::FamilyCookBook::App.controllers :shoppinglist do

  before do
    @logic_class = MTMD::FamilyCookBook::ShoppingListActions.new(params)
  end

  get :index  do
    @items = @logic_class.items
    render 'shoppinglist/index'
  end

  get :show, :with => '(:id)' do
    @shopping_list = @logic_class.check_shopping_list_id('id')

    unless @shopping_list
      flash[:error] = "Please provide a valid menu id!"
      redirect_to url(:shoppinglist, :index)
    end

    render 'shoppinglist/show'
  end

  get :edit, :with => '(:id)' do
    @shopping_list = @logic_class.check_shopping_list_id('id')

    unless @shopping_list
      flash[:error] = "Please provide a valid shopping list id!"
      redirect_to url(:shoppinglist, :index)
    end

    render 'shoppinglist/edit'
  end

  get :edit_single, :with => '(:id)' do
    @shopping_list = @logic_class.check_shopping_list_id('id')

    unless @shopping_list
      flash[:error] = "Please provide a valid shopping list id!"
      redirect_to url(:shoppinglist, :index)
    end

    render 'shoppinglist/edit_single'
  end

  put :update, :with => :id do
    shoppinglist = @logic_class.check_shopping_list_id('id')
    unless shoppinglist
      flash[:error] = "Please provide a valid shopping list id!"
      redirect_to url(:shoppinglist, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Shopping list has been save successfully."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:shoppinglist, :edit, shoppinglist.id)
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

  delete :destroy, :with => :id do
    shopping_list = @logic_class.check_shopping_list_id('id')

    unless shopping_list
      flash[:error] = "Please provide a valid shopping list id!"
      redirect_to url(:shoppinglist, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Shopping list has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:shoppinglist, :index)
  end

  delete :destroy_single_item, :with => [:id, :item_id] do
    shopping_list = @logic_class.check_shopping_list_id('id')

    unless shopping_list
      flash[:error] = "Please provide a valid shopping list id!"
      redirect_to url(:shoppinglist, :index)
    end

    shopping_list_item = @logic_class.check_shopping_list_item_id('item_id')

    unless shopping_list_item
      flash[:error] = "Please provide a valid shopping list item id!"
      redirect_to url(:shoppinglist, :edit_single, shopping_list.id)
    end

    status = @logic_class.destroy_single_item

    if status == true
      flash[:success] = "Shopping list item has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:shoppinglist, :edit_single, shopping_list.id)
  end

  put :toggle_item_active, :with => [:id, :ingredient_id, :unit_id] do
    shopping_list = @logic_class.check_shopping_list_id('id')
    unless shopping_list
      flash[:error] = "Please provide a valid shopping list!"
      redirect_to url(:shoppinglist, :index)
    end

    ingredient = @logic_class.check_ingredient_id('ingredient_id')
    unless ingredient
      flash[:error] = "Please provide a valid ingredient!"
      redirect_to url(:shoppinglist, :edit, shopping_list.id)
    end

    unit = @logic_class.check_unit_id('unit_id')
    unless unit
      flash[:error] = "Please provide a valid unit!"
      redirect_to url(:shoppinglist, :edit, shopping_list.id)
    end

    status = @logic_class.toggle_item_active(shopping_list.id, ingredient.id, unit.id)
    if status > 0
      flash[:success] = "Item has been hidden on shopping list."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:shoppinglist, :edit, shopping_list.id)
  end



end
