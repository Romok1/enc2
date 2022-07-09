class CreateRegionsTranslations < ActiveRecord::Migration[5.2]
  def change
    # @see https://github.com/globalize/globalize
    reversible do |dir|
      dir.up do
        Region.create_translation_table! name: :string
      end

      dir.down do
        Region.drop_translation_table!
      end
    end
  end
end
