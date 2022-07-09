class AddCartoFieldsToLayers < ActiveRecord::Migration[5.2]
  def change
    add_column :layers, :type, :string
    add_column :layers, :legend, :string
    add_column :layers, :tileset, :string
    add_column :layers, :carto_filters, :string
    add_column :layers, :carto_table, :string
    add_column :layers, :carto_colors, :string
  end
end
