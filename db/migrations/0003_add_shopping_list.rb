Sequel.migration do
  change do

    create_table(:shopping_lists) do
      primary_key :id

      foreign_key :menu_id, :menus, :deferrable => true, :null => false

      column :status,         String, :null => false, :default => 'open'
      column :title,          String
      column :description,    String

      # Modifiers
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz

      index :status
    end

    create_table(:shopping_list_items) do
      primary_key :id

      column :shopping_order, String,    :null => false
      column :type,           String,    :null => false
      column :active,         TrueClass, :default => true

      # Automated section
      foreign_key :shopping_list_id,       :shopping_lists,        :deferrable => true, :null => false
      foreign_key :recipe_id,              :recipes,               :deferrable => true
      foreign_key :menu_item_id,           :menu_items,            :deferrable => true
      foreign_key :ingredient_quantity_id, :ingredient_quantities, :deferrable => true

      # Individual section
      foreign_key :unit_id,       :units,       :deferrable => true
      foreign_key :ingredient_id, :ingredients, :deferrable => true
      column      :amount,        String

      # Modifiers
      column :created_at, :timestamptz
      column :updated_at, :timestamptz
    end

    create_join_table(:shopping_list_item_id => :shopping_list_items, :recipe_id              => :recipes)
    create_join_table(:shopping_list_item_id => :shopping_list_items, :menu_item_id           => :menu_items)
    create_join_table(:shopping_list_item_id => :shopping_list_items, :ingredient_quantity_id => :ingredient_quantities)
    create_join_table(:shopping_list_item_id => :shopping_list_items, :unit_id                => :units)
    create_join_table(:shopping_list_item_id => :shopping_list_items, :ingredient_id          => :ingredients)

  end
end
