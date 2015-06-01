Sequel.migration do
  change do
    create_table(:ingredients) do
      primary_key :id

      column :title,       String, :null => false
      column :description, String
      column :created_at, :timestamptz
      column :updated_at, :timestamptz

      index :title
    end

    create_table(:recipes) do
      primary_key :id

      column :title,                String, :null => false
      column :description,          String, :null => false
      column :tips_and_tricks,      String
      column :type,                 String
      column :difficulty,           Integer
      column :duration_cooking,     Integer
      column :duration_preparation, Integer
      column :cookware_amount,      Integer
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :title
      index :type
    end

    create_join_table(:ingredient_id => :ingredients, :recipe_id => :recipes)

    create_table(:recipe_ingredient_amounts) do
      primary_key :id

      foreign_key :recipe_id,     :recipes, :deferrable => true, :null => false
      foreign_key :ingredient_id, :ingredients, :deferrable => true, :null => false

      column :amount,     String, :null => false
      column :created_at, :timestamptz
      column :updated_at, :timestamptz

      index [:recipe_id, :ingredient_id]
      index :amount
    end

    create_table(:units) do
      primary_key :id

      column :name,        String
      column :description, String
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :name
    end

    create_table(:foodcalendar) do
      primary_key :id

      column :date_range,  Integer, :null => false
      column :name,        String
      column :description, String
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :name
    end


  end
end
