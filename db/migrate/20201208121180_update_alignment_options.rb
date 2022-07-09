class UpdateAlignmentOptions < ActiveRecord::Migration[5.2]
  def up

    execute "DROP TABLE IF EXISTS alignment_options"

    create_table :alignment_options do |t|
      t.integer :alignment_options_id
      t.column :biodiversity_module, :alignment_options_biodiversity_module
      t.text :description
      t.string :engagement_depth
      t.string :engagement_scope
      t.string :sbtn_step
      t.integer :sbtn_step_order
      t.string :biodiversity_metric
      t.string :future_scenario
      t.string :mitigation_hierarchy
      t.text :principle
      t.string :global_goal
      t.string :resource

      t.timestamps
    end

  end

  def down
    drop_table :alignment_options
  end
end
