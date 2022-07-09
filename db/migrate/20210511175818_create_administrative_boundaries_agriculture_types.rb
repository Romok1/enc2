class CreateAdministrativeBoundariesAgricultureTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :administrative_boundaries_agriculture_types do |t|
      t.integer :agriculture_type, null: false
      t.decimal :star_agriculture, null: false
      t.decimal :star_all, null: false

      t.references :country, foreign_key: true, index: true
      t.references :administrative_boundary, foreign_key: true,
        index: { name: 'index_admin_boundaries_agri_types_on_admin_boundary_id' }

      t.timestamps
    end
  end
end
