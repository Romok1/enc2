class AddEcoregionToMineIndicators < ActiveRecord::Migration[5.2]
  def change
    add_reference :mine_indicators, :ecoregion, foreign_key: true
  end
end
