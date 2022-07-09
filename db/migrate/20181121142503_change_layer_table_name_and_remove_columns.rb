class ChangeLayerTableNameAndRemoveColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :layers, :type
    remove_column :layers, :name
    remove_column :layers, :legend
    remove_column :layers, :tileset
    remove_column :layers, :carto_filters
    remove_column :layers, :carto_table
    remove_column :layers, :carto_colors
    add_reference :layers, :dataset, index: true

    rename_table :layers, :datasets_items_joins
  end
end
