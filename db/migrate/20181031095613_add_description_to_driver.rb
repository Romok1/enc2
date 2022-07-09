class AddDescriptionToDriver < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :description, :text
  end
end
