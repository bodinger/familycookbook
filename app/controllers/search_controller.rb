MTMD::FamilyCookBook::App.controllers :search do

  before do
    @logic_class = MTMD::FamilyCookBook::SearchActions.new(params)
  end

  post :recipe_by_ingredient do
    result_data   = @logic_class.results(:type => :recipe_by_ingredient)
    @controller   = {
      :controller => result_data[:controller],
      :action     => result_data[:action]
    }
    @items        = result_data[:results]
    @table_config = result_data[:table_config]
    @phrase       = result_data[:phrase]

    render 'search/result'
  end

  post :recipe_by_tag do
    result_data   = @logic_class.results(:type => :recipe_by_tag)
    @controller   = {
      :controller => result_data[:controller],
      :action     => result_data[:action]
    }
    @items        = result_data[:results]
    @table_config = result_data[:table_config]
    @phrase       = result_data[:phrase]

    render 'search/result'
  end

  get :index  do
    redirect_to(:index, :index)
  end

end
