extends 'links', :object => CDB::Ran::Links.new(@path)

if @pagination
  extends 'pagination', :object => @pagination
end
