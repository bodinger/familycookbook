attributes :id, :type, :navkey, :published, :top
child :teaser => :teaser do
  attributes :title, :image, :copyright, :image_alt
end
