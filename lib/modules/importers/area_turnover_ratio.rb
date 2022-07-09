module Importers
  class AreaTurnoverRatio < AgricultureBase
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

        agri_indicator.update(area_to_turnover_ratio: row['area_turnover_ratio']&.to_d)
        agri_indicator.save
      end
    end
  end
end
