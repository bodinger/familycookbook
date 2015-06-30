Sequel.migration do
  change do

    create_table(:shopping_lists) do
      primary_key :id

      column :shopping_order, String, :null => false
      column :type,           String, :null => false

      # Automated section
      foreign_key :menu_id,                :menus,                 :deferrable => true, :null => false
      foreign_key :menu_item_id,           :menu_items,            :deferrable => true, :null => false
      foreign_key :ingredient_quantity_id, :ingredient_quantities, :deferrable => true, :null => false

      # Individual section
      foreign_key :unit_id,              :units,              :deferrable => true
      foreign_key :ingredient_id,        :ingredients,        :deferrable => true

      column :amount,      String
      column :title,       String
      column :description, String

      # Modifiers
      column :created_at,  :timestamptz
      column :updated_at,  :timestamptz
    end

  end
end
