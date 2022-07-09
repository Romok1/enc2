class TranslationDeleteCascade < ActiveRecord::Migration[5.2]
  def up
    add_foreign_key :asset_translations, :assets, on_delete: :cascade
    add_foreign_key :assets_drivers_join_translations, :assets_drivers_joins, on_delete: :cascade
    add_foreign_key :benefit_translations, :benefits, on_delete: :cascade
    add_foreign_key :dataset_translations, :datasets, on_delete: :cascade
    add_foreign_key :driver_translations, :drivers, on_delete: :cascade
    add_foreign_key :ecosystem_service_translations, :ecosystem_services, on_delete: :cascade
    add_foreign_key :ecosystem_services_assets_join_translations, :ecosystem_services_assets_joins, on_delete: :cascade
    add_foreign_key :impact_driver_translations, :impact_drivers, on_delete: :cascade
    add_foreign_key :impact_translations, :impacts, on_delete: :cascade
    add_foreign_key :materiality_translations, :materialities, on_delete: :cascade
    add_foreign_key :methodology_criterium_translations, :methodology_criteria, on_delete: :cascade
    add_foreign_key :production_process_translations, :production_processes, on_delete: :cascade
    add_foreign_key :sector_translations, :sectors, on_delete: :cascade
    add_foreign_key :sub_industry_translations, :sub_industries, on_delete: :cascade
  end

  def down
    remove_foreign_key :assets_translations, :assets
    remove_foreign_key :assets_drivers_join_translations, :assets_drivers_joins
    remove_foreign_key :benefit_translations, :benefits
    remove_foreign_key :dataset_translations, :datasets
    remove_foreign_key :driver_translations, :drivers
    remove_foreign_key :ecosystem_service_translations, :ecosystem_services
    remove_foreign_key :ecosystem_services_assets_join_translations, :ecosystem_services_assets_joins
    remove_foreign_key :impact_driver_translations, :impact_drivers
    remove_foreign_key :impacts_translations, :impacts
    remove_foreign_key :materiality_translations, :materialities
    remove_foreign_key :methodology_criterium_translations, :methodology_criteria
    remove_foreign_key :production_process_translations, :production_processes
    remove_foreign_key :sector_translations, :sectors
    remove_foreign_key :sub_industry_translations, :sub_industries
  end
end
