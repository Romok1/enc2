class UpdateAgriIndicatorJoins < ActiveRecord::Migration[5.2]
  def up
    AgriIndicator.delete_all

    change_table :agri_indicators do |t|
      t.remove :eco_risk_min_id
      t.remove :eco_risk_max_id

      t.remove :representative_id

      t.remove :star_min_id
      t.remove :star_max_id

      t.references :eco_risk_min, foreign_key: { to_table: :ecoregions }, index: true
      t.references :eco_risk_max, foreign_key: { to_table: :ecoregions }, index: true
      t.references :eco_risk_representative, foreign_key: { to_table: :ecoregions }, index: true

      t.references :star_min,
        foreign_key: { to_table: :administrative_boundaries_agriculture_types },
        index: { name: 'index_min_admin_boundaries_agri_types_on_admin_boundary_id' }
      t.references :star_max,
        foreign_key: { to_table: :administrative_boundaries_agriculture_types },
        index: { name: 'index_max_admin_boundaries_agri_types_on_admin_boundary_id' }
      t.references :star_representative,
        foreign_key: { to_table: :administrative_boundaries_agriculture_types },
        index: { name: 'index_rep_admin_boundaries_agri_types_on_admin_boundary_id' }
    end
  end

  def down
    change_table :agri_indicators do |t|
      t.remove :eco_risk_min_id
      t.remove :eco_risk_max_id
      t.remove :eco_risk_representative_id

      t.remove :star_min_id
      t.remove :star_max_id
      t.remove :star_representative_id

      t.references :eco_risk_min, foreign_key: { to_table: :countries_ecoregions }, index: true
      t.references :eco_risk_max, foreign_key: { to_table: :countries_ecoregions }, index: true

      t.references :representative, foreign_key: { to_table: :countries_ecoregions }, index: true

      t.references :star_min, foreign_key: { to_table: :countries_ecoregions }, index: true
      t.references :star_max, foreign_key: { to_table: :countries_ecoregions }, index: true
    end
  end
end
