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

    alter_table(:ingredients) do
      drop_column(:ingredient_type_id)
      #add_column :type String
    end

    drop_table(:ingredient_types)

  end
end
