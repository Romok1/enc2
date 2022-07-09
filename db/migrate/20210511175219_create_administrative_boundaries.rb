class CreateAdministrativeBoundaries < ActiveRecord::Migration[5.2]
  def change
    create_table :administrative_boundaries do |t|
      t.string :external_id, null: false
      t.string :name, null: false
      t.references :country, foreign_key: true, index: true

      t.index :external_id, unique: true

      t.timestamps
    end
  end
end
