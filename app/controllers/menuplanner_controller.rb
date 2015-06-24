MTMD::FamilyCookBook::App.controllers :menuplanner do

  before do
    @logic_class = MTMD::FamilyCookBook::MenuplannerActions.new(params)
  end

  get :index  do
    @items      = @logic_class.menus
    render 'menuplanner/index'
  end

  get :new do
    @menu  = @logic_class.new
    @range = @logic_class.range
    render 'menuplanner/new'
  end

  get :show, :with => '(:id)' do
    @menu  = @logic_class.check_id

    unless @menu
      flash[:error] = "Please provide a valid menuplanner id!"
      redirect_to url(:menuplanner, :index)
    end

    render 'menuplanner/show'
  end

  post :create do
    menu = @logic_class.create

    unless menu
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Menu has been created."
    end

    redirect_to url(:menuplanner, :index)
  end

  get :edit, :with => '(:id)' do
    @menu  = @logic_class.check_id
    @range = @logic_class.range

    unless @menu
      flash[:error] = "Please provide a valid menu id!"
      redirect_to url(:menuplanner, :index)
    end

    render 'menuplanner/edit'
  end

  delete :destroy, :with => :id do
    menu = @logic_class.check_id

    unless menu
      flash[:error] = "Please provide a valid menu id!"
      redirect_to url(:menplanner, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Menu has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:menuplanner, :index)
  end

  put :update, :with => :id do
    menu = @logic_class.check_id
    unless menu
      flash[:error] = "Please provide a valid menu id!"
      redirect_to url(:menuplanner, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Menu has been save successfully."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:menuplanner, :show, menu.id)
  end

  put :toggle_shopping_list, :with => [:id, :menu_item_id] do
    menu = @logic_class.check_id
    unless menu
      flash[:error] = "Please provide a valid menu!"
      redirect_to url(:menuplanner, :index)
    end

    menu_item = @logic_class.check_menu_item_id
    unless menu_item
      flash[:error] = "Please provide a valid menu item id!"
      redirect_to url(:menuplanner, :edit, menu.id)
    end

    status = @logic_class.toggle_shopping_list(menu_item)
    if status == true
      flash[:success] = "Recipe has been removed from shopping list."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:menuplanner, :edit, menu.id)
  end

  delete :remove_menu_item_recipe, :with => [:id, :menu_item_id, :recipe_id] do
    menu = @logic_class.check_id
    unless menu
      flash[:error] = "Please provide a valid menu!"
      redirect_to url(:menuplanner, :index)
    end

    recipe_id = @logic_class.check_menu_item_recipe_id
    unless recipe_id
      flash[:error] = "Please provide a valid menu item or recipe!"
      redirect_to url(:menuplanner, :edit, menu.id)
    end

    @logic_class.remove_menu_item_recipe(params.fetch('menu_item_id', nil), recipe_id)
    flash[:success] = "The recipe has been removed."

    redirect_to url(:menuplanner, :edit, menu.id)
  end

end
