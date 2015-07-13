Sequel.migration do
  change do

    create_table(:ingredient_types) do
      primary_key :id

      column :title,       String, :null => false
      column :created_at, :timestamptz
      column :updated_at, :timestamptz

      index :title
    end

  end
end
