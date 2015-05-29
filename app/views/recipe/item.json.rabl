extends 'item'
node(:resource) { |item| url_for(:galleries, :show, :id => item.id, :format => :json) }
