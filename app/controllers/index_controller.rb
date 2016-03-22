MTMD::FamilyCookBook::App.controllers :index do

  get :index  do
    # @path = params[:path]
    # pagination = pagination_from_params
    #
    # @galleries = CDB::Ran::Gallery.by_path(@path, pagination)
    #
    # render 'galleries/index'
    render 'search/index'
  end

end
