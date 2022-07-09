class CreateMaterialities < ActiveRecord::Migration[5.2]
  def change
    create_table :materialities do |t|
      t.string :rag
      t.text :justification
      t.references :production_process, foreign_key: true
      t.references :ecosystem_service, foreign_key: true

      t.timestamps
    end
  end
end
