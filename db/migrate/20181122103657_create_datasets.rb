class CreateDatasets < ActiveRecord::Migration[5.2]
  def change
    create_table :datasets do |t|
      t.string :name
      t.string :map_type
      t.string :legend
      t.string :tileset
      t.string :carto_filters
      t.string :carto_table
      t.string :carto_colors

      t.timestamps
    end
  end
end
