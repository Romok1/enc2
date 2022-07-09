class ImpactDrivers < ActiveRecord::Migration[5.2]
  def change

    
    reversible do |dir|
      dir.down do
        ImpactDriver.drop_translation_table!
      end
      
      create_table :impact_drivers do |t|
        t.string :name
        
        t.timestamps
      end
      
      dir.up do
        ImpactDriver.create_translation_table! :name => :text
      end
    end
  end
end
