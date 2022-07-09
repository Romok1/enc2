module Concerns
  module Portfolios
    module NaturalCapital
      extend ActiveSupport::Concern

      included do
        private

        def natural_capital_overview
          {
            production_processes: natural_capital_production_processes,
            sub_industries: natural_capital_sub_industries
          }
        end

        def natural_capital_production_processes
          ProductionProcess.where(id: request_structure['production_process_ids'])
        end

        def natural_capital_sub_industries
          SubIndustry.where(id: request_structure['sub_industry_ids'])
        end

        def natural_capital_request_structure
          {
            sub_industry_ids: [],
            production_process_ids: []
          }
        end
      end
    end
  end
end
