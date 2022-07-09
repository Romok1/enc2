class AddDescriptionToAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :assets, :description, :text
  end
end
