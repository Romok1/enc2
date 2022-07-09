class Impacts < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.down do
        Impact.drop_translation_table!
      end
      
      create_table :impacts do |t|
        t.string :justification
        t.references :production_process, foreign_key: true
        t.references :impact_driver, foreign_key: true

        t.timestamps
      end


      dir.up do
        Impact.create_translation_table! :justification => :text
      end
    end
  end
end
