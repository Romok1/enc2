class CreateEcosystemServicesAssetsJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :ecosystem_services_assets_joins do |t|
      t.references :ecosystem_service, foreign_key: true
      t.references :asset, foreign_key: true
      t.string :importance
      t.text :justification

      t.timestamps
    end
  end
end
