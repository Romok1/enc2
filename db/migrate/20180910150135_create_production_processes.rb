class CreateProductionProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :production_processes do |t|
      t.string :name
      t.references :sub_industry, foreign_key: true

      t.timestamps
    end
  end
end
