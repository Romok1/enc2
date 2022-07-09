class DatasetsChangeColumnNames < ActiveRecord::Migration[5.2]
  def up
    rename_column :datasets, :carto_filters, :filters
    rename_column :datasets, :carto_colors, :colors
  end

  def down
    rename_column :datasets, :filters, :carto_filters
    rename_column :datasets, :colors, :carto_colors
  end
end
