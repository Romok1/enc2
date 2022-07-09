class CreateAgriIndicatorsV2 < ActiveRecord::Migration[5.2]
  def up
    create_agri_indicators_table
  end

  def down
    drop_table(:agri_indicators)
  end

  private

  def create_agri_indicators_table
    create_table(:agri_indicators) do |t|
      t.column :agriculture_type, :integer, default: nil
      t.decimal :area_to_turnover_ratio
      t.references :country, foreign_key: true, index: true
      t.references :eco_risk_min, foreign_key: { to_table: :countries_ecoregions }, index: true
      t.references :eco_risk_max, foreign_key: { to_table: :countries_ecoregions }, index: true
      t.references :star_min, foreign_key: { to_table: :countries_ecoregions }, index: true
      t.references :star_max, foreign_key: { to_table: :countries_ecoregions }, index: true
      t.references :representative, foreign_key: { to_table: :countries_ecoregions }, index: true

      t.timestamps
    end
  end
end
