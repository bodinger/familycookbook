Sequel.migration do
  up do

    existing_types = Sequel::Model.db[:ingredients].
      distinct(:type).
      where(Sequel.~(:type => nil), Sequel.~(:type => '')).
      select_map(:type)
    existing_types.each do |type|
      Sequel::Model.db[:ingredient_types].insert(
        :title      => type,
        :created_at => Time.now,
        :updated_at => Time.now
      )
    end

  end

  down do

    #drop_table(:ingredient_types)

  end
end
