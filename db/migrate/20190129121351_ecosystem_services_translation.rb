class EcosystemServicesTranslation < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        EcosystemService.create_translation_table! :name => :string, :description => :text, :category => :string, :category_description => :text
      end
      
      dir.down do
        EcosystemService.drop_translation_table!
      end
    end
  end
end
