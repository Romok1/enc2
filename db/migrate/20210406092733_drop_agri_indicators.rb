class DropAgriIndicators < ActiveRecord::Migration[5.2]
  def up
    drop_table(:agri_indicators)
  end

  def down
    create_table(:agri_indicators) do |t|
      t.string :crop
      t.decimal :star_agri_threat
      t.decimal :star_all_threat
      t.decimal :eco_risk
      t.decimal :area_to_turnover_ratio
      t.references :country, foreign_key: true, index: true
      t.references :representative_ecoregion_id, :ecoregion, foreign_key: { to_table: :agri_indicators }

      t.timestamps
    end
  end
end
