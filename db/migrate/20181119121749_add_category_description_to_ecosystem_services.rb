class AddCategoryDescriptionToEcosystemServices < ActiveRecord::Migration[5.2]
  def change
    add_column :ecosystem_services, :category_description, :text
  end
end
