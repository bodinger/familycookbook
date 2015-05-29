MTMD::FamilyCookBook::App.controllers :index do

  get :show do
    # id = params[:id].to_s
    #
    # @gallery = CDB::Ran::Gallery.by_id(id)
    #
    # if @gallery
    #   render 'galleries/detail'
    # else
    #   not_found
    # end
  end

  get :index  do
    # @path = params[:path]
    # pagination = pagination_from_params
    #
    # @galleries = CDB::Ran::Gallery.by_path(@path, pagination)
    #
    # render 'galleries/index'
    render 'index/index'
  end

end
