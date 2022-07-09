class CreateJoinTableAssetsDrivers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :assets, :drivers do |t|
      t.index [:asset_id, :driver_id]
      t.index [:driver_id, :asset_id]
    end
  end
end
