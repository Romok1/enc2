class AgriIndicatorsEcoregions < ActiveRecord::Migration[5.2]
  def change
    rename_column(:agri_indicators, :sub_sector, :agri_type)
    add_reference(:agri_indicators, :ecoregion, foreign_key: true)
    rename_column(:agri_indicators, :ecoregion_id, :representative_ecoregion_id) 
  end
end
