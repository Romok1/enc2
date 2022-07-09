class CreateJoinTableEcosystemServicesAssets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :ecosystem_services, :assets do |t|
      t.index([:ecosystem_service_id, :asset_id], name: 'idx_ecosystem_service_asset')
      t.index([:asset_id, :ecosystem_service_id], name: 'idx__asset_ecosystem_service')
    end
  end
end
