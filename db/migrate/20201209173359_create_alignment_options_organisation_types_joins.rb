class CreateAlignmentOptionsOrganisationTypesJoins < ActiveRecord::Migration[5.2]
  def up

    create_table :alignment_options_organisation_types_joins do |t|
      t.references :alignment_option, foreign_key: true, index: { name: :index_align_opt_org_type_join_on_align_opt_id }
      t.references :organisation_type, foreign_key: true, index: { name: :index_align_opt_org_type_join_on_org_type_id }
      t.integer :priority

      t.timestamps
    end

  end

  def down
    drop_table :alignment_options_organisation_types_joins
  end
end
