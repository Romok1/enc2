module Concerns
  module Portfolios
    module Agriculture
      extend ActiveSupport::Concern

      included do
        private

        def agriculture_overview
          request_structure['agriculture_dashboard'].map do |form|
            {
              country: agriculture_countries.find_by(iso_3: form['country']),
              crops_value: form['crops_value'],
              crops_area_type: form['crops_area_type'],
              livestock_value: form['livestock_value'],
              livestock_area_type: form['livestock_area_type']
            }
          end
        end

        def agriculture_countries
          Country.with_agriculture_countries.where(
            iso_3: request_structure['agriculture_dashboard'].map { |form| form['country'] }
          )
        end

        def agriculture_request_structure
          {
            agriculture_dashboard: %i[
              $_active
              country
              crops_value
              crops_area_type
              livestock_value
              livestock_area_type
            ]
          }
        end
      end
    end
  end
end
