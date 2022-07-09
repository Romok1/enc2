class CreateAssetsDriversJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :assets_drivers_joins do |t|
      t.references :asset, foreign_key: true
      t.references :driver, foreign_key: true
      t.string :influence
      t.text :justification
      t.text :likely_response
      t.text :effect_on_variability
      t.string :human_action_or_natural_variation
      t.string :timescale
      t.string :spatial_characteristics

      t.timestamps
    end
  end
end
