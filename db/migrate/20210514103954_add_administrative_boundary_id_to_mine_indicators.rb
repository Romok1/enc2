class AddAdministrativeBoundaryIdToMineIndicators < ActiveRecord::Migration[5.2]
  def change
    add_reference :mine_indicators, :administrative_boundary, foreign_key: true
  end
end
