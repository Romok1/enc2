class CreateAlignmentOptionsTranslations < ActiveRecord::Migration[5.2]
  def change
    # @see https://github.com/globalize/globalize
    reversible do |dir|
      dir.up do
        AlignmentOption.create_translation_table! description: :text,
                                                  link: :string

      end

      dir.down do
        AlignmentOption.drop_translation_table!
      end
    end
  end
end
