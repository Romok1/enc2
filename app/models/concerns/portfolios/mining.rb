module Concerns
  module Portfolios
    module Mining
      extend ActiveSupport::Concern
      include CompaniesHelper

      included do
        private

        def mining_overview
          request_structure['mining_dashboard'].map do |form|
            {
              company: company_from_id(form['company_id'], mining_companies),
              countries: mining_countries.where(iso_3: form['locations']),
            }
          end
        end

        def mining_companies
          Company.where(id: request_structure['mining_dashboard'].map { |form| form['company_id'] })
        end

        def mining_countries
          Country.where(iso_3: request_structure['mining_dashboard'].flat_map { |form| form['locations'] })
        end

        def mining_request_structure
          {
            mining_dashboard: [
              :'$_active',
              :company_id,
              {
                locations: []
              }
            ]
          }
        end
      end
    end
  end
end
