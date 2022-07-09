class CreateLayers < ActiveRecord::Migration[5.2]
  def change
    create_table :layers do |t|
      t.string :name
      t.references :mappable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
