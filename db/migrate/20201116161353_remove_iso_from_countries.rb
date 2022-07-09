class RemoveIsoFromCountries < ActiveRecord::Migration[5.2]
  def up
    remove_column :countries, :iso
  end

  def down
    add_column :countries, :iso, :string
  end
end
