class CreateOrganisationTypes < ActiveRecord::Migration[5.2]
  def up
    create_table :organisation_types do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end

  def down
    drop_table :organisation_types
  end
end
