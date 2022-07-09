class RemainingTranslations < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        EcosystemServicesAssetsJoin.create_translation_table! :justification => :text
        AssetsDriversJoin.create_translation_table! :justification => :text, :likely_response => :text, :effect_on_variability => :text, :human_action_or_natural_variation => :string, :timescale => :string, :spatial_characteristics => :string
        Benefit.create_translation_table! :name => :string
        Dataset.create_translation_table! :name => :string, :description => :text
        MethodologyCriterium.create_translation_table! :table_title => :string, :criterion => :string, :definition => :text, :red => :string, :amber => :string, :green => :string, :example => :text, :use_case => :text
      end
      
      dir.down do
        EcosystemServicesAssetsJoin.drop_translation_table!
        AssetsDriversJoin.drop_translation_table!
        Benefit.drop_translation_table!
        Dataset.drop_translation_table!
        MethodologyCriterium.drop_translation_table!
      end
    end

  end
end
