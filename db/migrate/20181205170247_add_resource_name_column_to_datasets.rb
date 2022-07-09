class AddResourceNameColumnToDatasets < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :resource_name, :text
  end
end
