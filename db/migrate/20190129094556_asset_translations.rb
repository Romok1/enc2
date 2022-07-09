class AssetTranslations < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Asset.create_translation_table! :name => :string, :description => :text, :data_needs => :string
      end

      dir.down do
        Asset.drop_translation_table!
      end
    end
  end
end
