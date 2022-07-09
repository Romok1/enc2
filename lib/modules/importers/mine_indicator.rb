module Importers
  class MineIndicator < Base
    COLUMNS = %w[
      mine_id
      country_code
      mineral
      star_all_threats
      star_mining_threats
      ecological_integrity_risk
      external_id
      ecoregion_name
      ecoregion_category
      administrative_boundary_id
      administrative_boundary_name
    ].freeze

    REQUIRED_COLUMNS = %w[
      mine_id
      country_code
      mineral
      star_all_threats
      star_mining_threats
      ecological_integrity_risk
      external_id
      ecoregion_name
      ecoregion_category
      administrative_boundary_id
      administrative_boundary_name
    ].freeze

    class << self
      def import(csv_path)
        new.run(csv_path)
      end
    end

    def run(csv_path)
      table = ::CSV.read(csv_path, headers: true, encoding: 'utf-8')

      raise 'Missing required headers.' unless (COLUMNS - table.headers).count.zero?

      ActiveRecord::Base.transaction do
        ::MineIndicator.destroy_all

        table.each do |row|
          with_row(row) do
            create_mine_indicator!(row)
          end
        end
      end
    end

    private

    def initialize
      @row_index = 1

      super
    end

    def with_row(row)
      sanitize_nulls!(row)
      @row_index += 1

      unless required_columns_present?(row)
        log('Required columns are nil or NA. Skipping...')
        return
      end

      country = ::Country.find_by(iso_3: row['country_code'])
      unless country
        Rails.logger.info "Country with ISO3 #{row['country_code']} not present in db. Skipping..."
        return
      end
      row['country_id'] = country.id # saves a lookup

      mineral = ::Mineral.find_by(name: row['mineral'])
      unless mineral
        Rails.logger.info "Mineral with name #{row['mineral']} not present in db. Skipping..."
        return
      end
      row['mineral_id'] = mineral.id # saves a lookup

      unless ::Ecoregion::CATEGORIES.include?(row['ecoregion_category'])
        Rails.logger.info "Ecoregion category '#{row['ecoregion_category']}' is not valid. Skipping..."
        return
      end

      yield
    end

    def create_mine_indicator!(row)
      ecoregion = find_or_create_ecoregion!(
        external_id: row['external_id'],
        name: row['ecoregion_name'],
        category: row['ecoregion_category']
      )

      administrative_boundary = find_or_create_administrative_boundary!(
        external_id: row['administrative_boundary_id'],
        name: row['administrative_boundary_name'],
        country_id: row['country_id']
      )

      attributes = {
        mine_id: row['mine_id'],
        star_mining_threat: row['star_mining_threats'].to_d,
        star_all_threat: row['star_all_threats'].to_d,
        eco_risk: row['ecological_integrity_risk'].to_d,
        mineral_id: row['mineral_id'],
        country_id: row['country_id'],
        ecoregion: ecoregion,
        administrative_boundary: administrative_boundary
      }
      ::MineIndicator.find_or_create_by!(attributes)
    end

    def find_or_create_ecoregion!(
      external_id:,
      name:,
      category:
    )
      ::Ecoregion.find_or_create_by!(
        external_id: external_id,
        name: name,
        category: category
      )
    end

    def find_or_create_administrative_boundary!(
      external_id:,
      name:,
      country_id:
    )
      ::AdministrativeBoundary.create_with(name: name, country_id: country_id)
        .find_or_create_by!(external_id: external_id)
    end

    def log(message)
      Rails.logger.info("Row #{@row_index}: #{message}")
    end

    def required_columns_present?(row)
      REQUIRED_COLUMNS.none? { |column| row[column].blank? }
    end

    def sanitize_nulls!(row)
      row.each { |k, v| row[k] = v == 'NA' ? nil : v } # replace occurrences of "NA" with nil
    end
  end
end
