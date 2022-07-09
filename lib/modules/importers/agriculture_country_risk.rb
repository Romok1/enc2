module Importers
  # NOTE: this data is not currently used in the tool
  # Leaving this in as it may be used in future updates when alighning with Post2020 goals
  class AgricultureCountryRisk < AgricultureBase
    class << self
      def import(csv_path)
        new.run(csv_path)
      end
    end

    def run(csv_path)
      CSV.foreach(csv_path, headers: true, encoding: 'utf-8') do |row|
        country = Country.find_by(iso_3: row['iso_3'])

        agri_indicator = AgriIndicator.find_or_create_by!(
          country: country,
          agriculture_type: sanitize_agriculture_type(row['agriculture_type'])
        )

        agri_indicator.update(total_star_all: row['total_star']&.to_d)
        agri_indicator.save
      end
    end
  end
end
