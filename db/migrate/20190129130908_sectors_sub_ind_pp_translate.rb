class SectorsSubIndPpTranslate < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Sector.create_translation_table! :name => :string
        SubIndustry.create_translation_table! :name => :string
        ProductionProcess.create_translation_table! :name => :string
      end
      
      dir.down do
        Sector.drop_translation_table!
        SubIndustry.drop_translation_table!
        ProductionProcess.drop_translation_table!
      end
    end

  end
end
