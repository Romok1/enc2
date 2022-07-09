class AddTotalRiskToAgriIndicator < ActiveRecord::Migration[5.2]
  def change
    add_column :agri_indicators, :total_star_all, :decimal
    add_column :agri_indicators, :total_eco_risk, :decimal
  end
end
