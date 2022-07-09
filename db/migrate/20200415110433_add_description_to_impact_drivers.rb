class AddDescriptionToImpactDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :impact_drivers, :description, :text
  end
end
