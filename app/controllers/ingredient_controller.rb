MTMD::FamilyCookBook::App.controllers :ingredient do

  get :show do
    not_found
  end

  get :index  do
    # @path = params[:path]
    # pagination = pagination_from_params
    #
    # @galleries = CDB::Ran::Gallery.by_path(@path, pagination)
    #
    # render 'galleries/index'
    render 'ingredient/index'
  end

end
