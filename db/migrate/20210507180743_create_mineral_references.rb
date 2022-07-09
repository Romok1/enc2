class CreateMineralReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :mineral_references do |t|
      t.string :name
      t.string :url
      t.references :mineral, foreign_key: true, index: true


      t.timestamps
    end
  end
end
