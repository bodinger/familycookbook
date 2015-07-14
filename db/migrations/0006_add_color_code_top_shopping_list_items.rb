Sequel.migration do
  change do
    alter_table(:shopping_list_items) do
      add_column :color_code, String
    end
  end
end
