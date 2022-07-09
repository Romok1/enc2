class AddJustificationAndReferencesToMinerals < ActiveRecord::Migration[5.2]
  def change
    add_column :minerals, :justification, :text

    reversible do |dir|
      dir.up do
        Mineral.add_translation_fields! justification: :text
      end

      dir.down do
        remove_column :mineral_translations, :justification
      end
    end
  end
end
