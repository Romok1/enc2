module Importers
  class AgricultureBase < Base
    def initialize(columns: [], required_columns: [])
      @row_index = 1
      @columns = columns
      @required_columns = required_columns

      super()
    end

    def with_row(row)
      sanitize_nulls!(row)
      @row_index += 1

      unless required_columns_present?(row)
        log('Required columns are nil or NA. Skipping...')
        return
      end

      agriculture_type = row['agriculture_type']
      unless valid_agriculture_type?(agriculture_type)
        log("Invalid Agriculture Type: #{agriculture_type}. Skipping...")
        return
      end

      country = Country.find_by(iso_3: row['iso_3'])
      unless country
        log("Country with ISO3 #{row['iso_3']} not present in db. Skipping...")
        return
      end

      row['country_id'] = country.id

      yield
    end

    def find_or_create_agri_indicator(row)
      attributes = {
        country_id: row['country_id'],
        agriculture_type: sanitize_agriculture_type(row['agriculture_type'])
      }

      AgriIndicator.find_or_create_by!(attributes)
    end

    def log(message)
      Rails.logger.info("Row #{@row_index}: #{message}")
    end

    def required_columns_present?(row)
      @required_columns.none? { |column| row[column].blank? }
    end

    def sanitize_nulls!(row)
      row.each { |k, v| row[k] = v == 'NA' ? nil : v } # replace occurrences of "NA" with nil
    end

    def sanitize_agriculture_type(agriculture_type)
      agriculture_type&.downcase&.to_sym
    end

    def valid_agriculture_type?(agriculture_type)
      AgricultureType::TYPES.include?(sanitize_agriculture_type(agriculture_type))
    end
  end
end
