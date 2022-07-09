class AddCategoryAndDescriptionToEcosystemServices < ActiveRecord::Migration[5.2]
  def change
    add_column :ecosystem_services, :category, :string
    add_column :ecosystem_services, :description, :text
  end
end
