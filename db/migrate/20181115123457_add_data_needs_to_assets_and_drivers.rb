class AddDataNeedsToAssetsAndDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :assets, :data_needs, :string
    add_column :drivers, :data_needs, :string
  end
end
