class AddColumnsToDatasets < ActiveRecord::Migration[5.2]
  def change
    add_column :datasets, :available, :boolean, default: false
    add_column :datasets, :description, :text
    add_column :datasets, :url, :string
  end
end
