class CreateSubIndustries < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_industries do |t|
      t.string :name
      t.references :sector, foreign_key: true

      t.timestamps
    end
  end
end
