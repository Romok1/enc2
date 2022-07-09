class CreateJoinTableDriversImpactDrivers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :drivers, :impact_drivers do |t|
      t.index [:driver_id, :impact_driver_id]
      t.index [:impact_driver_id, :driver_id]
    end
  end
end
