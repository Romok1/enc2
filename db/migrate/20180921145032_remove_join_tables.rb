class RemoveJoinTables < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :assets, :drivers
#    drop_join_table :ecosystem_services, :assets, table_name: 'idx_ecosystem_service_asset'
  end
end
