object @gallery
extends 'galleries/item'
child :images => :images do
  extends 'image'
end

attributes :url
