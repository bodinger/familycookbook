MTMD::FamilyCookBook::App.controllers :menuplanner do

  before do
    @logic_class = MTMD::FamilyCookBook::MenuplannerActions.new(params)
  end

  get :index  do
    @weekStartDay = @logic_class.currentWeekStartDay

    render 'menuplanner/index'
  end

  get :new do
    @unit = @logic_class.new
    render 'menuplanner/new'
  end

end
