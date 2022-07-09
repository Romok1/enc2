# frozen_string_literal: true
require 'csv'
module BiodiversityGoals
  module AgricultureDashboard
    class CSV < Dashboard
      HEADERS = %w[
        country_iso
        crops_value
        crops_area_type
        livestock_value
        livestock_area_type
      ].freeze

      def initialize(path)
        table = ::CSV.read(path, headers: true, converters: %i[numeric])

        raise ::CSV::MalformedCSVError unless (HEADERS - table.headers).count.zero?

        forms = []
        table.each do |row|
          forms.push({
            country: row['country_iso'].to_s.strip,
            crops_value: row['crops_value'].to_s.strip,
            crops_area_type: row['crops_area_type'].to_s.strip,
            livestock_value: row['livestock_value'].to_s.strip,
            livestock_area_type: row['livestock_area_type'].to_s.strip
          })
        end
        super(forms)
      end
    end
  end
end
