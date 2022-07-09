class CreateNationalResources < ActiveRecord::Migration[5.2]
  def change
    create_table :national_resources do |t|
      t.string :name
      t.string :region
      t.string :url
      t.references :mappable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
