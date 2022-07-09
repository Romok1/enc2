class AddExternalIdToEcoregions < ActiveRecord::Migration[5.2]
  def change
    add_column :ecoregions, :external_id, :bigint, unique: true
  end
end
