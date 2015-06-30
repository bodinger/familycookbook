Sequel.migration do
  change do
    alter_table(:ingredients) do
      add_column :type, String
    end
  end
end
