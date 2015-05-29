node(:links) do |links|
  links.controllers_with_content.each_with_object({}) do |controller, hash|
    hash[controller] = url_for(controller, :index, :path => @path, :format => :json)
  end
end
