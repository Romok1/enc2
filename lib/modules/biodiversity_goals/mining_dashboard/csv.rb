# frozen_string_literal: true

require 'csv'

module BiodiversityGoals
  module MiningDashboard
    class CSV < Dashboard
      HEADERS = %w[company_name country_isos].freeze

      def initialize(path)
        table = ::CSV.read(path, headers: true, converters: %i[numeric])

        raise ::CSV::MalformedCSVError unless (HEADERS - table.headers).count.zero?

        forms = []
        table.each do |row|
          forms.push({
            company_name: row['company_name'].to_s.strip,
            locations: row['country_isos'].to_s.split(',').map(&:strip)
          })
        end
        super(forms)
      end
    end
  end
end
