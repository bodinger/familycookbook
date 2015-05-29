Sequel.migration do
  change do
    create_table(:ingredients) do
      primary_key :id
      String :title, :null => false
      String :description
      timestamptz :created_at
      timestamptz :updated_at

      index :title
    end

    create_table(:recipes) do
      primary_key :id
      String :title, :null => false
      String :description, :null => false
      timestamptz :created_at
      timestamptz :updated_at

      index :title
    end

    create_join_table(:ingredient_id => :ingredients, :recipe_id => :recipes)

    create_table(:units) do
      primary_key :id
      String :name, :null => false
      String :description
      timestamptz :created_at
      timestamptz :updated_at

      index :name
    end

    create_table(:foodcalendar) do
      primary_key :id
      integer :date_range, :null => false
      String :title, :null => false
      String :description
      timestamptz :created_at
      timestamptz :updated_at

      index :title
    end


  end
end
