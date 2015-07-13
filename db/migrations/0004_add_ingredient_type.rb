Sequel.migration do
  up do

    create_table(:ingredient_types) do
      primary_key :id

      column :title,       String, :null => false
      column :created_at, :timestamptz
      column :updated_at, :timestamptz

      index :title
    end

    alter_table(:ingredients) do
      add_foreign_key :ingredient_type_id, :ingredient_types, :deferrable => true
    end

  end

  down do

    ingredients = Sequel::Model.db[:ingredients].all
    ingredients.each do |ingredient|
      next if ingredient[:ingredient_type_id].blank?
      ingredient_type = Sequel::Model.db[:ingredient_types].
        select(:title).
        where(:id => ingredient[:ingredient_type_id]).first

      Sequel::Model.db[:ingredients].
        where(
          :id => ingredient[:id]
        ).
        update(
          :type => ingredient_type[:title]
        )
    end

    alter_table(:ingredients) do
      drop_column(:ingredient_type_id)
    end

    drop_table(:ingredient_types)

  end
end
