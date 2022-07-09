class CreateAlignmentOptions < ActiveRecord::Migration[5.2]
  def up
    create_alignment_options_biodiversity_module

    create_table :alignment_options do |t|
      t.string :title
      t.references :organisation_type, foreign_key: true
      t.column :biodiversity_module, :alignment_options_biodiversity_module
      t.text :description
      t.string :link

      t.timestamps
    end
  end

  def down
    drop_table :alignment_options
    execute 'DROP TYPE alignment_options_biodiversity_module;'
  end

  private

  def create_alignment_options_biodiversity_module
    execute <<-DDL
      CREATE TYPE alignment_options_biodiversity_module AS ENUM (
        'agriculture',
        'mining'
      );
    DDL
  end
end
