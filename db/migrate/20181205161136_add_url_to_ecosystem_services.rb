class AddUrlToEcosystemServices < ActiveRecord::Migration[5.2]
  def change
    add_column :ecosystem_services, :url, :string
  end
end
