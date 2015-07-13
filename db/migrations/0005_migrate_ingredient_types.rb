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

    ingredients = Sequel::Model.db[:ingredients].all
    ingredients.each do |ingredient|
      Sequel::Model.db[:ingredients].
        where(:id => ingredient[:id]).
        update(
          :ingredient_type_id => Sequel::Model.db[:ingredient_types].
            select(:id).
            where(:title => ingredient[:type])
        )
    end

    alter_table(:ingredients) do
      drop_column(:type)
    end

  end

  down do

    alter_table(:ingredients) do
      add_column :type, String
    end

  end
end
