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

end
