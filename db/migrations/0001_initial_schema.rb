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
      column :calorie_indication,   Integer
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :title
      index :type
    end

    create_join_table(:ingredient_id => :ingredients, :recipe_id => :recipes)

    create_table(:units) do
      primary_key :id

      column :name,        String
      column :short_name,  String
      column :description, String
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :name
    end

    create_table(:ingredient_quantities) do
      primary_key :id

      foreign_key :recipe_id,     :recipes,     :deferrable => true, :null => false
      foreign_key :ingredient_id, :ingredients, :deferrable => true, :null => false
      foreign_key :unit_id,       :units,       :deferrable => true, :null => false

      column :amount,      String, :null => false
      column :portions,    String, :null => false
      column :description, String
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index [:recipe_id, :ingredient_id, :unit_id]
      index [:recipe_id, :ingredient_id]
      index [:recipe_id, :unit_id]
      index [:ingredient_id, :portions]
      index [:ingredient_id, :portions, :unit_id]
      index :amount
    end

    create_join_table(:ingredient_quantities_id => :ingredient_quantities, :recipe_id => :recipes)
    create_join_table(:ingredient_quantities_id => :ingredient_quantities, :ingredient_id => :ingredients)
    create_join_table(:unit_id => :units, :ingredient_quantities_id => :ingredient_quantities)

    create_table(:tags) do
      primary_key :id

      column :name,        String
      column :description, String
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :name
    end

    create_join_table(:tag_id => :tags, :recipe_id => :recipes)

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
