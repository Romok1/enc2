class CreateAgriIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table :agri_indicators do |t|
      t.string :sub_sector
      t.decimal :star_agri_threat
      t.decimal :star_all_threat
      t.decimal :eco_risk
      t.decimal :area_to_turnover_ratio
      t.references :country, foreign_key: true, index: true

      t.timestamps
    end
  end
end
