class AddDescriptionTranslationToImpactDriver < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        ImpactDriver.add_translation_fields! description: :text
      end

      dir.down do
        remove_column :impact_driver_translations, :description
      end
    end
  end
end
