MTMD::FamilyCookBook::App.controllers :unit do

  before do
    @logic_class = MTMD::FamilyCookBook::UnitActions.new(params)
  end

  get :as_array, :with => '(:q)' do
    content_type 'application/json;charset=utf8'

    @logic_class.unit_options.to_json
  end

  get :show, :with => '(:id)' do
    @unit = @logic_class.check_id

    unless @unit
      flash[:error] = "Please provide a valid unit id!"
      redirect_to url(:unit, :index)
    end

    render 'show'
  end

  get :index  do
    @pagination = pagination_from_params(@logic_class.params)
    @items      = @logic_class.units(@pagination)

    render 'unit/index'
  end

  get :new do
    @unit = @logic_class.new
    render 'unit/new'
  end

  post :create do
    unit = @logic_class.create

    unless unit
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Unit has been created."
    end

    redirect_to url(:unit, :index)
  end

  get :edit, :with => '(:id)' do
    @unit = @logic_class.check_id

    unless @unit
      flash[:error] = "Please provide a valid unit id!"
      redirect_to url(:unit, :index)
    end

    render 'unit/edit'
  end

  delete :destroy, :with => :id do
    unit = @logic_class.check_id

    unless unit
      flash[:error] = "Please provide a valid Unit id!"
      redirect_to url(:unit, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Unit has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:unit, :index)
  end

  put :update, :with => :id do
    unit = @logic_class.check_id
    unless unit
      flash[:error] = "Please provide a valid unit id!"
      redirect_to url(:unit, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Unit has been save successfully."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:unit, :edit, unit.id)
  end

end
