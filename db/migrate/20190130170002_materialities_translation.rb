class MaterialitiesTranslation < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Materiality.create_translation_table! :justification => :text
      end
      
      dir.down do
        Materiality.drop_translation_table!
      end
    end
  end
end
