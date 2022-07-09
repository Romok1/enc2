class CreateEcosystems < ActiveRecord::Migration[5.2]
  def change
    create_table :ecosystems do |t|
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Ecosystem.create_translation_table! name: :string
      end

      dir.down do
        Ecosystem.drop_translation_table!
      end
    end
  end
end
