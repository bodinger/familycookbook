MTMD::FamilyCookBook::App.controllers :search do

  before do
    @logic_class = MTMD::FamilyCookBook::SearchActions.new(params)
    @tabindex    = @logic_class.tabindex
  end

  post :recipe_by_ingredient do
    @result = @logic_class.results(:type => :recipe_by_ingredient)
    render 'search/result'
  end

  post :recipe_by_tag do
    @result = @logic_class.results(:type => :recipe_by_tag)
    render 'search/result'
  end

  post :recipe_by_ingredient_type do
    @result = @logic_class.results(:type => :recipe_by_ingredient_type)
    render 'search/result'
  end

  get :index  do
    redirect_to(:index, :index)
  end

end
