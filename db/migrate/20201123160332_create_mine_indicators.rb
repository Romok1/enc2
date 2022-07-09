class CreateMineIndicators < ActiveRecord::Migration[5.2]
  def up
    create_table :mine_indicators do |t|
      t.integer :mine_id, unique: true
      t.decimal :star_mining_threat
      t.decimal :star_all_threat
      t.decimal :eco_risk
      t.references :mineral, foreign_key: true, index: true
      t.references :country, foreign_key: true, index: true

      t.timestamps
    end

  end

  def down
    drop_table :mine_indicators
  end
end
