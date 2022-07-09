class AddEcoRiskToEcoregions < ActiveRecord::Migration[5.2]
  def change
    add_column :ecoregions, :eco_risk, :decimal, null: true
  end
end
