# frozen_string_literal: true

require 'csv'

# =======
# READ ME
# =======
# @see https://github.com/globalize/globalize
#
# If this file is modified, please use the command:
#
#   load "#{Rails.root}/lib/modules/importer.rb"
#
# to reload changes in console.
#
# To add a new importer, you currently have to take the following steps:
#
#   1. Append a constant reference to the default CSV (EN locale).
#   2. Append references in the import_all, delete_all & reset_ids methods.
#   3. Append the new import method.
#
# Most of the import methods use the following routine:
#
#   1. The alternate locale CSVs specified in IMPORT_LOCALES are loaded into a
#      variable to be read later.
#
#   2. The default CSV is read and iteration begins.
#   3. For each record, it's relevant model is either found or created
#      based upon the data in the default CSV and assigned to a variable.
#
#   4. Alternate locales are iterated over.
#   5. I18n temporarily uses the iterated locale.
#   6. Loaded translations (point 1) are used to update the model (point 3).
#
#
module Importer
  IMPORT_LOCALES = %w[es rt].freeze

  SECTORS_SUBINDUSTRIES_AND_PROCESSES = "#{Rails.root}/lib/data/seeds/sectors_subindustries_and_processes.csv"
  ECOSYSTEM_SERVICES                  = "#{Rails.root}/lib/data/seeds/ecosystem_services.csv"
  ASSETS                              = "#{Rails.root}/lib/data/seeds/assets.csv"
  DRIVERS                             = "#{Rails.root}/lib/data/seeds/drivers.csv"
  MATERIALITIES                       = "#{Rails.root}/lib/data/seeds/materialities.csv"
  ECOSYSTEM_SERVICES_ASSETS_JOIN      = "#{Rails.root}/lib/data/seeds/ecosystem_services_assets_join.csv"
  ASSETS_DRIVERS_JOIN                 = "#{Rails.root}/lib/data/seeds/assets_drivers_join.csv"
  BENEFITS                            = "#{Rails.root}/lib/data/seeds/benefits.csv"
  DATASETS                            = "#{Rails.root}/lib/data/seeds/datasets.csv"
  ECOSYSTEMS                          = "#{Rails.root}/lib/data/seeds/ecosystems.csv"
  DATASETS_ITEMS_JOIN                 = "#{Rails.root}/lib/data/seeds/datasets_items_join.csv"
  METHODOLOGY_CRITERIA                = "#{Rails.root}/lib/data/seeds/methodology_criteria.csv"
  NATIONAL_RESOURCES                  = "#{Rails.root}/lib/data/seeds/national_resources.csv"
  IMPACT_DRIVERS                      = "#{Rails.root}/lib/data/seeds/impact_drivers.csv"
  IMPACTS                             = "#{Rails.root}/lib/data/seeds/impacts.csv"
  DRIVERS_IMPACT_DRIVERS_JOIN         = "#{Rails.root}/lib/data/seeds/drivers_impact_drivers.csv"
  ORGANISATION_TYPES                  = "#{Rails.root}/lib/data/seeds/organisation_types.csv"
  COUNTRIES                           = "#{Rails.root}/lib/data/seeds/countries.csv"
  ALIGNMENT_OPTIONS                   = "#{Rails.root}/lib/data/seeds/alignment_options.csv"
  ALIGNMENT_OPTIONS_ORGANISATION_TYPES_JOIN = "#{Rails.root}/lib/data/seeds/alignment_options_organisation_types_join.csv"
  MINERALS                            = "#{Rails.root}/lib/data/seeds/mine_future_exposure.csv"
  MINE_INDICATORS                     = "#{Rails.root}/lib/data/seeds/mine_current_exposure.csv"
  MINES_COMPANIES_JOIN                = "#{Rails.root}/lib/data/seeds/mine_owners.csv"
  AGRICULTURE_STAR                    = "#{Rails.root}/lib/data/seeds/agriculture_star.csv"
  AGRICULTURE_ECO_RISK                = "#{Rails.root}/lib/data/seeds/agriculture_eco_risk.csv"
  AREA_TURNOVER_RATIO                 = "#{Rails.root}/lib/data/seeds/area_turnover_ratios.csv"
  AGRICULTURE_COUNTRY_RISK            = "#{Rails.root}/lib/data/seeds/agriculture_country_risk.csv"

  def self.import_all
    ActiveRecord::Base.transaction do
      import_sectors_subindustries_and_processes
      import_subindustries_processes_join
      import_ecosystem_services
      import_assets
      import_drivers
      import_materialities
      import_ecosystem_services_assets_join
      import_assets_drivers_join
      import_benefits
      import_benefits_ecosystem_services_join
      import_impact_drivers
      import_impacts
      import_drivers_impact_drivers_join
      import_datasets
      import_ecosystems
      import_datasets_items_join
      import_national_resources
      import_methodology_criteria
      import_alignment_options
      import_organisation_types
      import_alignment_options_organisation_types_join
      import_countries
      import_minerals
      import_mine_indicators
      import_mines_companies_join
      import_agriculture_star
      import_agriculture_eco_risk
      import_area_turnover_ratio
      import_agriculture_country_risk
      Rails.cache.clear
    end
  end

  # We should use destroy_all to ensure that model callbacks are triggered and
  # proper cleanup - such as related translation tables, are also destroyed.
  def self.delete_all
    destroy_all
  end

  def self.destroy_all
    ActiveRecord::Base.transaction do
      ::AlignmentOption.destroy_all
      ::AssetsDriversJoin.destroy_all
      ::EcosystemServicesAssetsJoin.destroy_all
      ::BenefitsEcosystemServicesJoin.destroy_all
      ::SubIndustryProductionProcessJoin.destroy_all
      ::DatasetsItemsJoin.destroy_all
      ::Ecosystem.destroy_all
      ::Materiality.destroy_all
      ::Driver.destroy_all
      ::Impact.destroy_all
      ::ImpactDriver.destroy_all
      ::Asset.destroy_all
      ::EcosystemService.destroy_all
      ::ProductionProcess.destroy_all
      ::SubIndustry.destroy_all
      ::Sector.destroy_all
      ::Benefit.destroy_all
      ::Dataset.destroy_all
      ::MethodologyCriterium.destroy_all
      ::NationalResource.destroy_all
      ::AgriIndicator.destroy_all
      ::Mineral.destroy_all
      ::MineIndicator.destroy_all
      ::MinesCompaniesJoin.destroy_all
      ::AdministrativeBoundariesAgricultureType.destroy_all
      ::AdministrativeBoundary.destroy_all
      ::Ecoregion.destroy_all
      ::Country.destroy_all
      reset_ids
    end
  end

  def self.reset_ids
    # Note - these raw SQL queries to reset autoinc ids are postgreSQL specific, e.g. MySQL needs an ALTER TABLE for this
    ::AssetsDriversJoin.connection.execute('ALTER SEQUENCE assets_drivers_joins_id_seq RESTART WITH 1')
    ::EcosystemServicesAssetsJoin.connection.execute('ALTER SEQUENCE ecosystem_services_assets_joins_id_seq RESTART WITH 1')
    ::BenefitsEcosystemServicesJoin.connection.execute('ALTER SEQUENCE benefits_ecosystem_services_joins_id_seq RESTART WITH 1')
    ::SubIndustryProductionProcessJoin.connection.execute('ALTER SEQUENCE sub_industry_production_process_joins_id_seq RESTART WITH 1')
    ::DatasetsItemsJoin.connection.execute('ALTER SEQUENCE datasets_items_joins_id_seq RESTART WITH 1')
    ::Materiality.connection.execute('ALTER SEQUENCE materialities_id_seq RESTART WITH 1')
    ::Driver.connection.execute('ALTER SEQUENCE drivers_id_seq RESTART WITH 1')
    ::Impact.connection.execute('ALTER SEQUENCE impacts_id_seq RESTART WITH 1')
    ::ImpactDriver.connection.execute('ALTER SEQUENCE impact_drivers_id_seq RESTART WITH 1')
    ::Asset.connection.execute('ALTER SEQUENCE assets_id_seq RESTART WITH 1')
    ::EcosystemService.connection.execute('ALTER SEQUENCE ecosystem_services_id_seq RESTART WITH 1')
    ::ProductionProcess.connection.execute('ALTER SEQUENCE production_processes_id_seq RESTART WITH 1')
    ::SubIndustry.connection.execute('ALTER SEQUENCE sub_industries_id_seq RESTART WITH 1')
    ::Sector.connection.execute('ALTER SEQUENCE sectors_id_seq RESTART WITH 1')
    ::Benefit.connection.execute('ALTER SEQUENCE benefits_id_seq RESTART WITH 1')
    ::Dataset.connection.execute('ALTER SEQUENCE datasets_id_seq RESTART WITH 1')
    ::MethodologyCriterium.connection.execute('ALTER SEQUENCE methodology_criteria_id_seq RESTART WITH 1')
    ::NationalResource.connection.execute('ALTER SEQUENCE national_resources_id_seq RESTART WITH 1')
    ::OrganisationType.connection.execute('ALTER SEQUENCE organisation_types_id_seq RESTART WITH 1')
    ::Country.connection.execute('ALTER SEQUENCE countries_id_seq RESTART WITH 1')
    ::AlignmentOption.connection.execute('ALTER SEQUENCE alignment_options_id_seq RESTART WITH 1')
    ::AdministrativeBoundary.connection.execute('ALTER SEQUENCE administrative_boundaries_id_seq RESTART WITH 1')
    ::AdministrativeBoundariesAgricultureType.connection.execute('ALTER SEQUENCE administrative_boundaries_agriculture_types_id_seq RESTART WITH 1')
  end

  def self.find_mappable_for_dataset_join(row)
    if row['Asset'].present?
      Asset.find_by!(name: row['Asset'].strip)
    elsif row['Driver'].present?
      Driver.find_by!(name: row['Driver'].strip)
    elsif row['Impact Driver'].present?
      ImpactDriver.find_by!(name: row['Impact Driver'].strip)
    elsif row['Ecosystem'].present?
      Ecosystem.find_by!(name: row['Ecosystem'].strip)
    else
      raise "Couldn't identify the asset, driver, impact driver or ecosystem this layer maps to"
    end
  end

  def self.locale_filename(filename, locale)
    filename.gsub(/csv$/, locale + '.csv')
  end

  def self.slurp_translations(filename)
    translations = {}
    IMPORT_LOCALES.each do |locale|
      locale_file = locale_filename(filename, locale)
      next unless File.exist?(locale_file)

      translations[locale] = CSV.read(locale_file, headers: true, encoding: 'utf-8')
    end
    translations
  end

  def self.import_sectors_subindustries_and_processes
    ActiveRecord::Base.transaction do
      translations = slurp_translations(SECTORS_SUBINDUSTRIES_AND_PROCESSES)

      CSV.foreach(SECTORS_SUBINDUSTRIES_AND_PROCESSES, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        sector_name             = row['Sector'].strip
        sub_industry_name       = row['Subindustry'].strip
        production_process_name = row['Process'].strip

        sector = Sector.find_or_create_by!(name: sector_name)

        sub_industry = SubIndustry.find_or_create_by!(
          name: sub_industry_name,
          sector: sector
        )

        prod_process = ProductionProcess.find_or_create_by!(
          name: production_process_name
        )

        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            sector.name = trans_row['Sector'].strip
            sector.save
            sub_industry.name = trans_row['Subindustry'].strip
            sub_industry.save
            prod_process.name = trans_row['Process'].strip
            prod_process.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_subindustries_processes_join
    ActiveRecord::Base.transaction do
      CSV.foreach(SECTORS_SUBINDUSTRIES_AND_PROCESSES, headers: true, encoding: 'utf-8') do |row|
        sub_industry        = SubIndustry.find_by!(name: row['Subindustry'].strip)
        production_process  = ProductionProcess.find_by!(name: row['Process'].strip)

        SubIndustryProductionProcessJoin.find_or_create_by!(
          production_process: production_process,
          sub_industry: sub_industry
        )
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_ecosystem_services
    ActiveRecord::Base.transaction do
      CSV.foreach(ECOSYSTEM_SERVICES, headers: true, encoding: 'utf-8') do |row|
        EcosystemService.find_or_create_by!(
          name: row['Ecosystem Service'].strip,
          category: row['Category'].strip,
          description: row['Description'],
          category_description: row['Category Description'],
          url: row['URL']
        )
      end
    end

    IMPORT_LOCALES.each do |locale|
      locale_file = locale_filename(ECOSYSTEM_SERVICES, locale)
      next unless File.exist?(locale_file)

      ActiveRecord::Base.transaction do
        I18n.with_locale(locale) do
          CSV.foreach(locale_file, headers: true, encoding: 'utf-8').with_index(1) do |row, id|
            curr_es = EcosystemService.find(id)
            next if curr_es.nil?

            curr_es.name = row['Ecosystem Service'].strip
            curr_es.description = row['Description']
            curr_es.category = row['Category'].strip
            curr_es.category_description = row['Category Description']
            curr_es.url = row['URL']
            curr_es.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_assets
    ActiveRecord::Base.transaction do
      CSV.foreach(ASSETS, headers: true, encoding: 'utf-8') do |row|
        Asset.find_or_create_by!(
          name: row['Asset'].strip,
          description: row['Description'],
          data_needs: row['Data Needs']
        )
      end
    end
    IMPORT_LOCALES.each do |locale|
      locale_file = locale_filename(ASSETS, locale)
      next unless File.exist?(locale_file)

      ActiveRecord::Base.transaction do
        I18n.with_locale(locale) do
          CSV.foreach(locale_file, headers: true, encoding: 'utf-8').with_index(1) do |row, id|
            curr_asset = Asset.find(id)
            next if curr_asset.nil?

            curr_asset.name = row['Asset'].strip
            curr_asset.description = row['Description'].strip
            curr_asset.data_needs = row['Data Needs'].strip
            curr_asset.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_drivers
    ActiveRecord::Base.transaction do
      CSV.foreach(DRIVERS, headers: true, encoding: 'utf-8') do |row|
        Driver.find_or_create_by!(
          name: row['Driver of change'].strip,
          description: row['Description'],
          data_needs: row['Data Needs']
        )
      end
    end
    IMPORT_LOCALES.each do |locale|
      locale_file = locale_filename(DRIVERS, locale)
      next unless File.exist?(locale_file)

      ActiveRecord::Base.transaction do
        I18n.with_locale(locale) do
          CSV.foreach(locale_file, headers: true, encoding: 'utf-8').with_index(1) do |row, id|
            curr_driver = Driver.find(id)
            next if curr_driver.nil?

            curr_driver.name = row['Driver of change'].strip
            curr_driver.description = row['Description'].strip
            curr_driver.data_needs = row['Data Needs'].strip
            curr_driver.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_materialities
    ActiveRecord::Base.transaction do
      translations = slurp_translations(MATERIALITIES)

      CSV.foreach(MATERIALITIES, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        ecosystem_service   = EcosystemService.find_by!(name: row['Ecosystem Service'].strip)
        production_process  = ProductionProcess.find_by!(name: row['Process'].strip)

        materiality = Materiality.find_or_create_by!(
          ecosystem_service: ecosystem_service,
          production_process: production_process,
          rag: row['RAG'],
          justification: row['Justification']
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            materiality.justification = trans_row['Justification']
            materiality.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_ecosystem_services_assets_join
    ActiveRecord::Base.transaction do
      translations = slurp_translations(ECOSYSTEM_SERVICES_ASSETS_JOIN)

      CSV.foreach(ECOSYSTEM_SERVICES_ASSETS_JOIN, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        ecosystem_service   = EcosystemService.find_by!(name: row['Ecosystem Service'].strip)
        asset               = Asset.find_by!(name: row['Asset'].strip)

        join = EcosystemServicesAssetsJoin.find_or_create_by!(
          ecosystem_service: ecosystem_service,
          asset: asset,
          importance: row['Importance'],
          justification: row['Justification']
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            join.justification = trans_row['Justification']
            join.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_assets_drivers_join
    ActiveRecord::Base.transaction do
      translations = slurp_translations(ASSETS_DRIVERS_JOIN)
      CSV.foreach(ASSETS_DRIVERS_JOIN, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        asset   = Asset.find_by!(name: row['Asset'].strip)
        driver  = Driver.find_by!(name: row['Driver'].strip)

        join = AssetsDriversJoin.find_or_create_by!(
          asset: asset,
          driver: driver,
          influence: row['Influence'],
          justification: row['Justification'],
          likely_response: row['Likely Response'],
          effect_on_variability: row['Effect on Variability'],
          human_action_or_natural_variation: row['Human action or natural variation'],
          timescale: row['Timescale'],
          spatial_characteristics: row['Spatial Characteristics']
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            join.justification                     = trans_row['Justification']
            join.likely_response                   = trans_row['Likely Response']
            join.effect_on_variability             = trans_row['Effect on Variability']
            join.human_action_or_natural_variation = trans_row['Human action or natural variation']
            join.timescale                         = trans_row['Timescale']
            join.spatial_characteristics           = trans_row['Spatial Characteristics']
            join.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_benefits
    ActiveRecord::Base.transaction do
      translations = slurp_translations(BENEFITS)
      CSV.foreach(BENEFITS, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        benefit = Benefit.find_or_create_by!(name: row['Benefit'].strip)
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            benefit.name = trans_row['Benefit']
            benefit.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_benefits_ecosystem_services_join
    ActiveRecord::Base.transaction do
      CSV.foreach(BENEFITS, headers: true, encoding: 'utf-8') do |row|
        ecosystem_service = EcosystemService.find_by!(name: row['Ecosystem Service'].strip)
        benefit           = Benefit.find_by!(name: row['Benefit'].strip)

        BenefitsEcosystemServicesJoin.find_or_create_by!(
          ecosystem_service: ecosystem_service,
          benefit: benefit
        )
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_impact_drivers
    ActiveRecord::Base.transaction do
      CSV.foreach(IMPACT_DRIVERS, headers: true, encoding: 'utf-8') do |row|
        ImpactDriver.find_or_create_by!(
          name: row['Impact Driver'].strip,
          description: row['Description'].strip
        )
      end
    end
    IMPORT_LOCALES.each do |locale|
      locale_file = locale_filename(IMPACT_DRIVERS, locale)
      next unless File.exist?(locale_file)

      ActiveRecord::Base.transaction do
        I18n.with_locale(locale) do
          CSV.foreach(locale_file, headers: true, encoding: 'utf-8').with_index(1) do |row, id|
            curr_impact_driver = ImpactDriver.find(id)
            next if curr_impact_driver.nil?

            curr_impact_driver.name = row['Impact Driver'].strip
            curr_impact_driver.description = row['Description'].strip
            curr_impact_driver.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_impacts
    ActiveRecord::Base.transaction do
      translations = slurp_translations(IMPACTS)

      CSV.foreach(IMPACTS, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        production_process = ProductionProcess.find_by(name: row[0].strip)
        impact_driver = ImpactDriver.find_by(name: row[1].strip)
        next if production_process.nil? || impact_driver.nil? || row[3].nil?

        impact = Impact.find_or_create_by!(
          production_process: production_process,
          impact_driver: impact_driver,
          rag: row[2],
          justification: row[3]
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          trans_row = translations[locale][ln]
          next if trans_row.nil?

          I18n.with_locale(locale) do
            impact.justification = trans_row['Justification']
            impact.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_drivers_impact_drivers_join
    ActiveRecord::Base.transaction do
      CSV.foreach(DRIVERS_IMPACT_DRIVERS_JOIN, headers: true, encoding: 'utf-8') do |row|
        @row = row
        driver = Driver.find_by!(name: row['Driver'])
        impact_driver = ImpactDriver.find_by!(name: row['Impact driver'])
        driver.impact_drivers << impact_driver unless driver.impact_drivers.include?(impact_driver)
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_datasets
    # Assumes name is unique

    ActiveRecord::Base.transaction do
      translations = slurp_translations(DATASETS)
      CSV.foreach(DATASETS, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        dataset_attributes = {
          name: row['Name'],
          resource_name: row['Resource Name'],
          map_type: row['Type'],
          legend: row['Legend'],
          tileset: row['Tileset'],
          filters: row['Filters'],
          carto_table: row['Carto Table'],
          colors: row['Colors'],
          available: row['Available'],
          description: row['Description'],
          url: row['Url'],
          source_layer: row['Source Layer'],
          opacity: row['Opacity']
        }

        @dataset = Dataset.find_by(name: row['Name'])

        if @dataset.nil?
          @dataset = Dataset.create(dataset_attributes)
          IMPORT_LOCALES.each do |locale|
            next if translations[locale].nil?

            I18n.with_locale(locale) do
              trans_row = translations[locale][ln]
              next if trans_row.nil?

              @dataset.name        = trans_row['Name']
              @dataset.description = trans_row['Description']
              @dataset.save
            end
          end
        else
          # Update only if data differs between csv and database
          @dataset.assign_attributes(dataset_attributes)
          @dataset.update_attributes(dataset_attributes) if @dataset.changed?
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  #TODO: import translations
  def self.import_ecosystems
    ActiveRecord::Base.transaction do
      CSV.foreach(ECOSYSTEMS, headers: true, encoding: 'utf-8') do |row|
        Ecosystem.find_or_create_by(name: row['Name'])
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_datasets_items_join
    ActiveRecord::Base.transaction do
      CSV.foreach(DATASETS_ITEMS_JOIN, headers: true, encoding: 'utf-8') do |row|
        dataset = Dataset.find_by!(name: row['Dataset'])

        @row = row

        DatasetsItemsJoin.find_or_create_by!(
          mappable: find_mappable_for_dataset_join(row),
          dataset: dataset
        )
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_national_resources
    ActiveRecord::Base.transaction do
      CSV.foreach(NATIONAL_RESOURCES, headers: true, encoding: 'utf-8') do |row|
        NationalResource.find_or_create_by!(
          name: row['Name'],
          region: row['Region'],
          url: row['Url'],
          mappable: find_mappable_for_dataset_join(row)
        )
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_methodology_criteria
    ActiveRecord::Base.transaction do
      translations = slurp_translations(METHODOLOGY_CRITERIA)
      CSV.foreach(METHODOLOGY_CRITERIA, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        criterium = MethodologyCriterium.find_or_create_by!(
          table_id: row['Table'],
          table_title: row['Title'],
          criterion: row['Criterion'],
          definition: row['Definition'],
          red: row['RED'],
          amber: row['AMBER'],
          green: row['GREEN'],
          example: row['Example'],
          use_case: row['Use case for risk management']
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            criterium.table_title = trans_row['Title']
            criterium.criterion = trans_row['Criterion']
            criterium.definition = trans_row['Definition']
            criterium.red = trans_row['RED']
            criterium.amber = trans_row['AMBER']
            criterium.green = trans_row['GREEN']
            criterium.example = trans_row['Example']
            criterium.use_case = trans_row['Use case for risk management']
            criterium.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_organisation_types
    ActiveRecord::Base.transaction do
      translations = slurp_translations(ORGANISATION_TYPES)

      CSV.foreach(ORGANISATION_TYPES, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        organisation_type = OrganisationType.find_or_create_by!(
          name: row['Name']
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            organisation_type.name = trans_row['Name']
            organisation_type.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_countries
    ActiveRecord::Base.transaction do
      translations = slurp_translations(COUNTRIES)

      CSV.foreach(COUNTRIES, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        region = Region.find_or_create_by!(name: row['Region'])

        country = Country.find_or_create_by!(
          name: row['Country'],
          iso_3: row['ISO 3'],
          region: region
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            region.update(name: trans_row['Region'])
            country.update(name: trans_row['Country'])
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_alignment_options
    ActiveRecord::Base.transaction do
      translations = slurp_translations(ALIGNMENT_OPTIONS)

      CSV.foreach(ALIGNMENT_OPTIONS, headers: true, encoding: 'utf-8').with_index(0) do |row, ln|
        alignment_option = AlignmentOption.find_or_create_by!(
          alignment_options_id: row['AlignmentOptionId'],
          description: row['Description'],
          biodiversity_module: row['Biodiversity Module'].downcase,
          engagement_depth: row['Engagement depth'],
          engagement_scope: row['Engagement scope'],
          sbtn_step: row['SBTN step'],
          sbtn_step_order: row['SBTN step order'],
          biodiversity_metric: row['Biodiversity metric'],
          future_scenario: row['Future scenario'],
          mitigation_hierarchy: row['Mitigation Hierarchy'],
          principle: row['Principle or Practice'],
          resource: row['Resource']
        )
        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            alignment_option.tap do |o|
              o.biodiversity_module = trans_row['Biodiversity Module'].downcase
              o.description = trans_row['Description']
              o.resource = trans_row['Resource']
            end.save
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_alignment_options_organisation_types_join
    ActiveRecord::Base.transaction do
      CSV.foreach(ALIGNMENT_OPTIONS_ORGANISATION_TYPES_JOIN, headers: true, encoding: 'utf-8') do |row|
        align_option = AlignmentOption.find_by(alignment_options_id: row['AlignmentOptionId'])

        unless align_option
          Rails.logger.info "AlignmentOption with id #{row['AlignmentOptionId']} not present in db. Skipping..."
          next
        end

        org_type = OrganisationType.find_by(name: row['Organisation type'])

        unless org_type
          Rails.logger.info "OrganisationType with name #{row['Organisation type']} not present in db. Skipping..."
          next
        end

        attributes = {
          alignment_option: align_option,
          organisation_type: org_type,
          priority: row['Priority for display']
        }

        AlignmentOptionsOrganisationTypesJoin.find_or_create_by!(attributes)
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_agriculture_star
    Importers::AgricultureStar.import(AGRICULTURE_STAR)
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_agriculture_eco_risk
    Importers::AgricultureEcoRisk.import(AGRICULTURE_ECO_RISK)
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_area_turnover_ratio
    ActiveRecord::Base.transaction do
      Importers::AreaTurnoverRatio.import(AREA_TURNOVER_RATIO)
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  # NOTE: this data is not currently used in the tool
  # Leaving this in as it may be used in future updates when alighning with Post2020 goals
  def self.import_agriculture_country_risk
    ActiveRecord::Base.transaction do
      Importers::AgricultureCountryRisk.import(AGRICULTURE_COUNTRY_RISK)
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_minerals
    ActiveRecord::Base.transaction do
      translations = slurp_translations(MINERALS)

      CSV.foreach(MINERALS, headers: true, encoding: 'utf-8') do |row, ln|
        mineral = Mineral.find_or_create_by!(
          name: row['mineral_name'],
          is_aligned: row['transition_alignment']&.downcase,
          justification: row['justification'],
          star_avg: row['star_avg'].to_d,
          star_max: row['star_max'].to_d,
          star_min: row['star_min'].to_d,
          eco_risk_avg: row['eco_risk_avg'].to_d,
          eco_risk_max: row['eco_risk_max'].to_d,
          eco_risk_min: row['eco_risk_min'].to_d
        )

        import_mineral_references(mineral, row)

        IMPORT_LOCALES.each do |locale|
          next if translations[locale].nil?

          I18n.with_locale(locale) do
            trans_row = translations[locale][ln]
            next if trans_row.nil?

            mineral.update_attributes(name: trans_row['mineral_name'])
            mineral.update_attributes(name: trans_row['justification'])
          end
        end
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_mineral_references(mineral, row)
    (1..3).each do |n|
      break unless row["reference_#{n}_text"]

      MineralReference.find_or_create_by!(
        mineral: mineral,
        name: row["reference_#{n}_text"],
        url: row["reference_#{n}_link"]
      )
    end
  end

  def self.import_mine_indicators
    Importers::MineIndicator.import(MINE_INDICATORS)
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  def self.import_mines_companies_join
    ActiveRecord::Base.transaction do
      CSV.foreach(MINES_COMPANIES_JOIN, headers: true, encoding: 'utf-8') do |row|
        company = Company.find_or_create_by(name: row['company'])
        unless company
          Rails.logger.info "Company with name #{row['company']} not present in db. Skipping..."
          next
        end
        mine = MineIndicator.find_by(mine_id: row['mine_id'])
        unless mine
          Rails.logger.info "Mine with id #{row['mine_id']} not present in db. Skipping..."
          next
        end
        attributes = {
          mine_indicator: mine,
          company: company,
          relationship: row['relationship']&.downcase
        }
        MinesCompaniesJoin.find_or_create_by!(attributes)
      end
    end
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end

  # DO NOT DELETE: un-pivots provided format - used when new pivot data is provided to convert to format for import
  def self.process_impacts(impacts_file)
    File.open('frog.csv', 'w') do |file|
      CSV.foreach(impacts_file, headers: true, encoding: 'utf-8') do |row|
        row.each do |header, field|
          next if header == 'Production process'
          next if field == 'NA'
          next if field.blank?
          next if header.blank?

          file.write "\"#{row[0]}\",\"#{header}\",\"#{field}\"\n"
        end
      end
    end
    file.close
  rescue StandardError => e
    Rails.env.development? ? raise : Appsignal.set_error(e)
  end
end
