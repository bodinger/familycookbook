object false
extends 'item_list'

node(:resource) { url_for(:galleries, :index, :path => @path, :format => :json) }

child @galleries => :contents do
  extends 'galleries/item'
end
