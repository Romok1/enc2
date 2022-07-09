class CreateMinerals < ActiveRecord::Migration[5.2]
  def up

    create_energy_transition_enum

    create_table :minerals do |t|
      t.string  :name
      t.decimal :star_avg
      t.decimal :star_min
      t.decimal :star_max
      t.decimal :eco_risk_avg
      t.decimal :eco_risk_min
      t.decimal :eco_risk_max
      t.column  :is_aligned, :mineral_aligned_energy

      t.timestamps
    end


  end

  def down
    drop_table :minerals
    execute <<-SQL
      DROP TYPE mineral_aligned_energy;
    SQL
  end

  private

  def create_energy_transition_enum
    execute <<-DDL
      CREATE TYPE mineral_aligned_energy AS ENUM (
        'true',
        'false',
        'not assessed'
      );
    DDL
  end
end
