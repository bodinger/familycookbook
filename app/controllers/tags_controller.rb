MTMD::FamilyCookBook::App.controllers :tag do

  before do
    @logic_class = MTMD::FamilyCookBook::TagActions.new(params)
  end

  get :as_array, :with => '(:q)' do
    content_type 'application/json;charset=utf8'
    @logic_class.tag_options.to_json
  end

  get :show, :with => '(:id)' do
    @tag = @logic_class.check_id

    unless @tag
      flash[:error] = "Please provide a valid tag id!"
      redirect_to url(:tag, :index)
    end

    render 'show'
  end

  get :index, :with => '(:page, :limit)'  do
    @pagination = pagination_from_params(@logic_class.params)
    @items      = @logic_class.tags(@pagination)

    render 'tag/index'
  end

  get :new do
    @tag = @logic_class.new
    render 'tag/new'
  end

  post :create do
    tag = @logic_class.create

    unless tag
      flash[:error] = "An error has occurred!"
    else
      flash[:success] = "Tag has been created."
    end

    redirect_to url(:tag, :index)
  end

  get :edit, :with => '(:id)' do
    @tag = @logic_class.check_id

    unless @tag
      flash[:error] = "Please provide a valid tag id!"
      redirect_to url(:tag, :index)
    end

    render 'tag/edit'
  end

  delete :destroy, :with => :id do
    tag = @logic_class.check_id

    unless tag
      flash[:error] = "Please provide a valid tag id!"
      redirect_to url(:tag, :index)
    end

    status = @logic_class.destroy

    if status == true
      flash[:success] = "Tag has been deleted."
    else
      flash[:error] = "An error has occurred!"
    end

    redirect_to url(:tag, :index)
  end

  put :update, :with => :id do
    tag = @logic_class.check_id
    unless tag
      flash[:error] = "Please provide a valid tag id!"
      redirect_to url(:tag, :index)
    end

    status = @logic_class.update
    if status == true
      flash[:success] = "Tag has been save successfully."
    else
      flash[:message] = "Nothing has been saved/changed!"
    end
    redirect_to url(:tag, :edit, tag.id)
  end

end
