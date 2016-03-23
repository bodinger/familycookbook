MTMD::FamilyCookBook::App.controllers :index do

  get :index  do
    @logic_class = MTMD::FamilyCookBook::SearchActions.new(params)
    @tabindex    = @logic_class.tabindex
    render 'search/index'
  end

end
