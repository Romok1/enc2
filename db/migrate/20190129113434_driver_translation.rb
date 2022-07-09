class DriverTranslation < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        Driver.create_translation_table! :name => :string, :description => :text, :data_needs => :string
      end
      
      dir.down do
        Driver.drop_translation_table!
      end
    end
  end
end
