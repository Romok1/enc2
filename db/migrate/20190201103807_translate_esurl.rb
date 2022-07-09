class TranslateEsurl < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        EcosystemService.add_translation_fields! url: :string
      end

      dir.down do
        remove_column :ecosystem_service_translations, :url
      end
    end
  end
end
