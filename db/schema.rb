# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_14_103954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "administrative_boundaries", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "name", null: false
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_administrative_boundaries_on_country_id"
    t.index ["external_id"], name: "index_administrative_boundaries_on_external_id", unique: true
  end

  create_table "administrative_boundaries_agriculture_types", force: :cascade do |t|
    t.integer "agriculture_type", null: false
    t.decimal "star_agriculture", null: false
    t.decimal "star_all", null: false
    t.bigint "country_id"
    t.bigint "administrative_boundary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrative_boundary_id"], name: "index_admin_boundaries_agri_types_on_admin_boundary_id"
    t.index ["country_id"], name: "index_administrative_boundaries_agriculture_types_on_country_id"
  end

  create_table "agri_indicators", force: :cascade do |t|
    t.integer "agriculture_type"
    t.decimal "area_to_turnover_ratio"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "eco_risk_min_id"
    t.bigint "eco_risk_max_id"
    t.bigint "eco_risk_representative_id"
    t.bigint "star_min_id"
    t.bigint "star_max_id"
    t.bigint "star_representative_id"
    t.decimal "total_star_all"
    t.decimal "total_eco_risk"
    t.index ["country_id"], name: "index_agri_indicators_on_country_id"
    t.index ["eco_risk_max_id"], name: "index_agri_indicators_on_eco_risk_max_id"
    t.index ["eco_risk_min_id"], name: "index_agri_indicators_on_eco_risk_min_id"
    t.index ["eco_risk_representative_id"], name: "index_agri_indicators_on_eco_risk_representative_id"
    t.index ["star_max_id"], name: "index_max_admin_boundaries_agri_types_on_admin_boundary_id"
    t.index ["star_min_id"], name: "index_min_admin_boundaries_agri_types_on_admin_boundary_id"
    t.index ["star_representative_id"], name: "index_rep_admin_boundaries_agri_types_on_admin_boundary_id"
  end

  create_table "alignment_option_translations", force: :cascade do |t|
    t.bigint "alignment_option_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "link"
    t.index ["alignment_option_id"], name: "index_alignment_option_translations_on_alignment_option_id"
    t.index ["locale"], name: "index_alignment_option_translations_on_locale"
  end

# Could not dump table "alignment_options" because of following StandardError
#   Unknown type 'alignment_options_biodiversity_module' for column 'biodiversity_module'

  create_table "alignment_options_organisation_types_joins", force: :cascade do |t|
    t.bigint "alignment_option_id"
    t.bigint "organisation_type_id"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alignment_option_id"], name: "index_align_opt_org_type_join_on_align_opt_id"
    t.index ["organisation_type_id"], name: "index_align_opt_org_type_join_on_org_type_id"
  end

  create_table "asset_translations", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.string "data_needs"
    t.index ["asset_id"], name: "index_asset_translations_on_asset_id"
    t.index ["locale"], name: "index_asset_translations_on_locale"
  end

  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "data_needs"
  end

  create_table "assets_drivers_join_translations", force: :cascade do |t|
    t.bigint "assets_drivers_join_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "justification"
    t.text "likely_response"
    t.text "effect_on_variability"
    t.string "human_action_or_natural_variation"
    t.string "timescale"
    t.string "spatial_characteristics"
    t.index ["assets_drivers_join_id"], name: "index_868255ecf2427b6db795a0241b24b60f177ed5fb"
    t.index ["locale"], name: "index_assets_drivers_join_translations_on_locale"
  end

  create_table "assets_drivers_joins", force: :cascade do |t|
    t.bigint "asset_id"
    t.bigint "driver_id"
    t.string "influence"
    t.text "justification"
    t.text "likely_response"
    t.text "effect_on_variability"
    t.string "human_action_or_natural_variation"
    t.string "timescale"
    t.string "spatial_characteristics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_assets_drivers_joins_on_asset_id"
    t.index ["driver_id"], name: "index_assets_drivers_joins_on_driver_id"
  end

  create_table "assets_ecosystem_services", id: false, force: :cascade do |t|
    t.bigint "ecosystem_service_id", null: false
    t.bigint "asset_id", null: false
    t.index ["asset_id", "ecosystem_service_id"], name: "idx__asset_ecosystem_service"
    t.index ["ecosystem_service_id", "asset_id"], name: "idx_ecosystem_service_asset"
  end

  create_table "benefit_translations", force: :cascade do |t|
    t.bigint "benefit_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["benefit_id"], name: "index_benefit_translations_on_benefit_id"
    t.index ["locale"], name: "index_benefit_translations_on_locale"
  end

  create_table "benefits", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "benefits_ecosystem_services_joins", force: :cascade do |t|
    t.bigint "benefit_id"
    t.bigint "ecosystem_service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_benefits_ecosystem_services_joins_on_benefit_id"
    t.index ["ecosystem_service_id"], name: "index_benefits_ecosystem_services_joins_on_ecosystem_service_id"
  end

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "categorized_type", null: false
    t.index ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true
  end

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "categorized_type", null: false
    t.integer "categorized_id", null: false
    t.index ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true
  end

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", default: "", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position"
  end

  create_table "comfy_cms_fragments", force: :cascade do |t|
    t.string "record_type"
    t.bigint "record_id"
    t.string "identifier", null: false
    t.string "tag", default: "text", null: false
    t.text "content"
    t.boolean "boolean", default: false, null: false
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boolean"], name: "index_comfy_cms_fragments_on_boolean"
    t.index ["datetime"], name: "index_comfy_cms_fragments_on_datetime"
    t.index ["identifier"], name: "index_comfy_cms_fragments_on_identifier"
    t.index ["record_type", "record_id"], name: "index_comfy_cms_fragments_on_record_type_and_record_id"
  end

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "parent_id"
    t.string "app_layout"
    t.string "label", null: false
    t.string "identifier", null: false
    t.text "content"
    t.text "css"
    t.text "js"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position"
    t.index ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true
  end

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "layout_id"
    t.integer "parent_id"
    t.integer "target_page_id"
    t.string "label", null: false
    t.string "slug"
    t.string "full_path", null: false
    t.text "content_cache"
    t.integer "position", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.boolean "is_published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_published"], name: "index_comfy_cms_pages_on_is_published"
    t.index ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position"
    t.index ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path"
  end

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.index ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at"
  end

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string "label", null: false
    t.string "identifier", null: false
    t.string "hostname", null: false
    t.string "path"
    t.string "locale", default: "en", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hostname"], name: "index_comfy_cms_sites_on_hostname"
  end

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "identifier", null: false
    t.text "content"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true
    t.index ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position"
  end

  create_table "comfy_cms_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.integer "page_id", null: false
    t.integer "layout_id"
    t.string "label", null: false
    t.text "content_cache"
    t.boolean "is_published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_published"], name: "index_comfy_cms_translations_on_is_published"
    t.index ["locale"], name: "index_comfy_cms_translations_on_locale"
    t.index ["page_id"], name: "index_comfy_cms_translations_on_page_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.text "name"
    t.string "iso_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "region_id"
    t.index ["region_id"], name: "index_countries_on_region_id"
  end

  create_table "country_translations", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["country_id"], name: "index_country_translations_on_country_id"
    t.index ["locale"], name: "index_country_translations_on_locale"
  end

  create_table "dataset_translations", force: :cascade do |t|
    t.bigint "dataset_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.index ["dataset_id"], name: "index_dataset_translations_on_dataset_id"
    t.index ["locale"], name: "index_dataset_translations_on_locale"
  end

  create_table "datasets", force: :cascade do |t|
    t.string "name"
    t.string "map_type"
    t.string "legend"
    t.string "tileset"
    t.string "filters"
    t.string "carto_table"
    t.string "colors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "available", default: false
    t.text "description"
    t.string "url"
    t.text "resource_name"
    t.string "source_layer"
    t.float "opacity"
  end

  create_table "datasets_items_joins", force: :cascade do |t|
    t.string "mappable_type"
    t.bigint "mappable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "dataset_id"
    t.index ["dataset_id"], name: "index_datasets_items_joins_on_dataset_id"
    t.index ["mappable_type", "mappable_id"], name: "index_datasets_items_joins_on_mappable_type_and_mappable_id"
  end

  create_table "driver_translations", force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.string "data_needs"
    t.index ["driver_id"], name: "index_driver_translations_on_driver_id"
    t.index ["locale"], name: "index_driver_translations_on_locale"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "data_needs"
  end

  create_table "drivers_impact_drivers", id: false, force: :cascade do |t|
    t.bigint "driver_id", null: false
    t.bigint "impact_driver_id", null: false
    t.index ["driver_id", "impact_driver_id"], name: "index_drivers_impact_drivers_on_driver_id_and_impact_driver_id"
    t.index ["impact_driver_id", "driver_id"], name: "index_drivers_impact_drivers_on_impact_driver_id_and_driver_id"
  end

  create_table "ecoregions", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "external_id"
    t.decimal "eco_risk"
  end

  create_table "ecosystem_service_translations", force: :cascade do |t|
    t.bigint "ecosystem_service_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.string "category"
    t.text "category_description"
    t.string "url"
    t.index ["ecosystem_service_id"], name: "index_ecosystem_service_translations_on_ecosystem_service_id"
    t.index ["locale"], name: "index_ecosystem_service_translations_on_locale"
  end

  create_table "ecosystem_services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.text "description"
    t.text "category_description"
    t.string "url"
  end

  create_table "ecosystem_services_assets_join_translations", force: :cascade do |t|
    t.bigint "ecosystem_services_assets_join_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "justification"
    t.index ["ecosystem_services_assets_join_id"], name: "index_c211f21bccdc11c1da1323312682726f7405cb2d"
    t.index ["locale"], name: "index_ecosystem_services_assets_join_translations_on_locale"
  end

  create_table "ecosystem_services_assets_joins", force: :cascade do |t|
    t.bigint "ecosystem_service_id"
    t.bigint "asset_id"
    t.string "importance"
    t.text "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_ecosystem_services_assets_joins_on_asset_id"
    t.index ["ecosystem_service_id"], name: "index_ecosystem_services_assets_joins_on_ecosystem_service_id"
  end

  create_table "ecosystem_translations", force: :cascade do |t|
    t.bigint "ecosystem_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["ecosystem_id"], name: "index_ecosystem_translations_on_ecosystem_id"
    t.index ["locale"], name: "index_ecosystem_translations_on_locale"
  end

  create_table "ecosystems", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impact_driver_translations", force: :cascade do |t|
    t.bigint "impact_driver_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name"
    t.text "description"
    t.index ["impact_driver_id"], name: "index_impact_driver_translations_on_impact_driver_id"
    t.index ["locale"], name: "index_impact_driver_translations_on_locale"
  end

  create_table "impact_drivers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "impact_translations", force: :cascade do |t|
    t.bigint "impact_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "justification"
    t.index ["impact_id"], name: "index_impact_translations_on_impact_id"
    t.index ["locale"], name: "index_impact_translations_on_locale"
  end

  create_table "impacts", force: :cascade do |t|
    t.string "justification"
    t.bigint "production_process_id"
    t.bigint "impact_driver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rag"
    t.index ["impact_driver_id"], name: "index_impacts_on_impact_driver_id"
    t.index ["production_process_id"], name: "index_impacts_on_production_process_id"
  end

  create_table "materialities", force: :cascade do |t|
    t.string "rag"
    t.text "justification"
    t.bigint "production_process_id"
    t.bigint "ecosystem_service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ecosystem_service_id"], name: "index_materialities_on_ecosystem_service_id"
    t.index ["production_process_id"], name: "index_materialities_on_production_process_id"
  end

  create_table "materiality_translations", force: :cascade do |t|
    t.bigint "materiality_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "justification"
    t.index ["locale"], name: "index_materiality_translations_on_locale"
    t.index ["materiality_id"], name: "index_materiality_translations_on_materiality_id"
  end

  create_table "methodology_criteria", force: :cascade do |t|
    t.bigint "table_id"
    t.string "table_title"
    t.string "criterion"
    t.text "definition"
    t.string "red"
    t.string "amber"
    t.string "green"
    t.text "example"
    t.text "use_case"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "methodology_criterium_translations", force: :cascade do |t|
    t.bigint "methodology_criterium_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "table_title"
    t.string "criterion"
    t.text "definition"
    t.string "red"
    t.string "amber"
    t.string "green"
    t.text "example"
    t.text "use_case"
    t.index ["locale"], name: "index_methodology_criterium_translations_on_locale"
    t.index ["methodology_criterium_id"], name: "index_4f2b6819e852befa48f3e8ae061eb35408285810"
  end

  create_table "mine_indicators", force: :cascade do |t|
    t.integer "mine_id"
    t.decimal "star_mining_threat"
    t.decimal "star_all_threat"
    t.decimal "eco_risk"
    t.bigint "mineral_id"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ecoregion_id"
    t.bigint "administrative_boundary_id"
    t.index ["administrative_boundary_id"], name: "index_mine_indicators_on_administrative_boundary_id"
    t.index ["country_id"], name: "index_mine_indicators_on_country_id"
    t.index ["ecoregion_id"], name: "index_mine_indicators_on_ecoregion_id"
    t.index ["mineral_id"], name: "index_mine_indicators_on_mineral_id"
  end

  create_table "mineral_references", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.bigint "mineral_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mineral_id"], name: "index_mineral_references_on_mineral_id"
  end

  create_table "mineral_translations", force: :cascade do |t|
    t.bigint "mineral_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "justification"
    t.index ["locale"], name: "index_mineral_translations_on_locale"
    t.index ["mineral_id"], name: "index_mineral_translations_on_mineral_id"
  end

# Could not dump table "minerals" because of following StandardError
#   Unknown type 'mineral_aligned_energy' for column 'is_aligned'

# Could not dump table "mines_companies_joins" because of following StandardError
#   Unknown type 'mines_companies_relationship' for column 'relationship'

  create_table "national_resources", force: :cascade do |t|
    t.string "name"
    t.string "region"
    t.string "url"
    t.string "mappable_type"
    t.bigint "mappable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mappable_type", "mappable_id"], name: "index_national_resources_on_mappable_type_and_mappable_id"
  end

  create_table "organisation_type_translations", force: :cascade do |t|
    t.bigint "organisation_type_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_organisation_type_translations_on_locale"
    t.index ["organisation_type_id"], name: "index_organisation_type_translations_on_organisation_type_id"
  end

  create_table "organisation_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "portfolios" because of following StandardError
#   Unknown type 'dashboard_types' for column 'portfolio_type'

  create_table "production_process_translations", force: :cascade do |t|
    t.bigint "production_process_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_production_process_translations_on_locale"
    t.index ["production_process_id"], name: "index_production_process_translations_on_production_process_id"
  end

  create_table "production_processes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "region_translations", force: :cascade do |t|
    t.bigint "region_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_region_translations_on_locale"
    t.index ["region_id"], name: "index_region_translations_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sector_translations", force: :cascade do |t|
    t.bigint "sector_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_sector_translations_on_locale"
    t.index ["sector_id"], name: "index_sector_translations_on_sector_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_industries", force: :cascade do |t|
    t.string "name"
    t.bigint "sector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sector_id"], name: "index_sub_industries_on_sector_id"
  end

  create_table "sub_industry_production_process_joins", force: :cascade do |t|
    t.bigint "sub_industry_id"
    t.bigint "production_process_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["production_process_id"], name: "index_production_process_sub_industry"
    t.index ["sub_industry_id"], name: "index_sub_industry_production_process"
  end

  create_table "sub_industry_translations", force: :cascade do |t|
    t.bigint "sub_industry_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["locale"], name: "index_sub_industry_translations_on_locale"
    t.index ["sub_industry_id"], name: "index_sub_industry_translations_on_sub_industry_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name"
    t.text "organisation"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.bigint "organisation_type_id"
    t.bigint "country_id"
    t.boolean "agreed_to_contact_for_new_functionality_updates", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_type_id"], name: "index_users_on_organisation_type_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "administrative_boundaries", "countries"
  add_foreign_key "administrative_boundaries_agriculture_types", "administrative_boundaries"
  add_foreign_key "administrative_boundaries_agriculture_types", "countries"
  add_foreign_key "agri_indicators", "administrative_boundaries_agriculture_types", column: "star_max_id"
  add_foreign_key "agri_indicators", "administrative_boundaries_agriculture_types", column: "star_min_id"
  add_foreign_key "agri_indicators", "administrative_boundaries_agriculture_types", column: "star_representative_id"
  add_foreign_key "agri_indicators", "countries"
  add_foreign_key "agri_indicators", "ecoregions", column: "eco_risk_max_id"
  add_foreign_key "agri_indicators", "ecoregions", column: "eco_risk_min_id"
  add_foreign_key "agri_indicators", "ecoregions", column: "eco_risk_representative_id"
  add_foreign_key "alignment_options_organisation_types_joins", "alignment_options"
  add_foreign_key "alignment_options_organisation_types_joins", "organisation_types"
  add_foreign_key "asset_translations", "assets", on_delete: :cascade
  add_foreign_key "assets_drivers_join_translations", "assets_drivers_joins", on_delete: :cascade
  add_foreign_key "assets_drivers_joins", "assets"
  add_foreign_key "assets_drivers_joins", "drivers"
  add_foreign_key "benefit_translations", "benefits", on_delete: :cascade
  add_foreign_key "benefits_ecosystem_services_joins", "benefits"
  add_foreign_key "benefits_ecosystem_services_joins", "ecosystem_services"
  add_foreign_key "countries", "regions"
  add_foreign_key "dataset_translations", "datasets", on_delete: :cascade
  add_foreign_key "driver_translations", "drivers", on_delete: :cascade
  add_foreign_key "ecosystem_service_translations", "ecosystem_services", on_delete: :cascade
  add_foreign_key "ecosystem_services_assets_join_translations", "ecosystem_services_assets_joins", on_delete: :cascade
  add_foreign_key "ecosystem_services_assets_joins", "assets"
  add_foreign_key "ecosystem_services_assets_joins", "ecosystem_services"
  add_foreign_key "impact_driver_translations", "impact_drivers", on_delete: :cascade
  add_foreign_key "impact_translations", "impacts", on_delete: :cascade
  add_foreign_key "impacts", "impact_drivers"
  add_foreign_key "impacts", "production_processes"
  add_foreign_key "materialities", "ecosystem_services"
  add_foreign_key "materialities", "production_processes"
  add_foreign_key "materiality_translations", "materialities", on_delete: :cascade
  add_foreign_key "methodology_criterium_translations", "methodology_criteria", on_delete: :cascade
  add_foreign_key "mine_indicators", "administrative_boundaries"
  add_foreign_key "mine_indicators", "countries"
  add_foreign_key "mine_indicators", "ecoregions"
  add_foreign_key "mine_indicators", "minerals"
  add_foreign_key "mineral_references", "minerals"
  add_foreign_key "mines_companies_joins", "companies"
  add_foreign_key "mines_companies_joins", "mine_indicators"
  add_foreign_key "portfolios", "users"
  add_foreign_key "production_process_translations", "production_processes", on_delete: :cascade
  add_foreign_key "sector_translations", "sectors", on_delete: :cascade
  add_foreign_key "sub_industries", "sectors"
  add_foreign_key "sub_industry_production_process_joins", "production_processes"
  add_foreign_key "sub_industry_production_process_joins", "sub_industries"
  add_foreign_key "sub_industry_translations", "sub_industries", on_delete: :cascade
  add_foreign_key "users", "countries"
  add_foreign_key "users", "organisation_types"
end
