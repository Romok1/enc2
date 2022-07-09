class DropCountriesEcoregions < ActiveRecord::Migration[5.2]
  def up
    drop_join_table(:countries, :ecoregions)
  end

  def down
    create_join_table(:countries, :ecoregions) do |t|
      t.primary_key :id
      t.column :agriculture_type, :integer, default: nil

      t.decimal :star_agriculture, null: true
      t.decimal :star_all, null: true

      t.references :country, foreign_key: true, index: true
      t.references :ecoregion, foreign_key: true, index: true
    end
  end
end
