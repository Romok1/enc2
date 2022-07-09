module Importers
  class AgricultureEcoRisk < AgricultureBase
    COLUMNS = %w[
      agriculture_type
      iso_3
      representative_ecoregion_id
      representative_ecoregion_eco_risk
      representative_ecoregion_category
      representative_ecoregion_name
      max_ecoregion_id
      max_ecoregion_eco_risk
      max_ecoregion_category
      max_ecoregion_name
      min_ecoregion_id
      min_ecoregion_eco_risk
      min_ecoregion_category
      min_ecoregion_name
    ].freeze

    REQUIRED_COLUMNS = %w[
      agriculture_type
      iso_3
      representative_ecoregion_id
      representative_ecoregion_eco_risk
      representative_ecoregion_category
      representative_ecoregion_name
    ].freeze

    class << self
      def import(csv_path)
        new(columns: COLUMNS, required_columns: REQUIRED_COLUMNS).run(csv_path)
      end
    end

    def run(csv_path)
      table = ::CSV.read(csv_path, headers: true, encoding: 'utf-8')

      raise 'Missing required headers.' unless (COLUMNS - table.headers).count.zero?

      ActiveRecord::Base.transaction do
        table.each do |row|
          with_row(row) do
            create_or_update_agri_indicator_and_ecoregions(row)
          end
        end
      end
    end

    private

    def create_or_update_agri_indicator_and_ecoregions(row)
      agri_indicator = find_or_create_agri_indicator(row)
      attributes = {}

      # create & set the min, max and representative ecoregion relations
      %i[min max representative].each do |ecoregion_type|
        ecoregion_attributes = generate_ecoregion_attributes({
          ecoregion_type: ecoregion_type,
          row: row
        })

        attributes["eco_risk_#{ecoregion_type}".to_sym] = create_or_update_ecoregion(ecoregion_attributes)
      end

      agri_indicator.update(attributes)
      agri_indicator.save
    end

    def generate_ecoregion_attributes(row:, ecoregion_type:)
      sanitize_ecoregion_attributes({
        name: row["#{ecoregion_type}_ecoregion_name"],
        eco_risk: row["#{ecoregion_type}_ecoregion_eco_risk"],
        category: row["#{ecoregion_type}_ecoregion_category"],
        external_id: row["#{ecoregion_type}_ecoregion_id"]
      })
    end

    def sanitize_ecoregion_attributes(attributes)
      category = attributes[:category]&.upcase
      eco_risk = attributes[:eco_risk]&.to_d

      attributes[:name] = attributes[:name]&.strip
      attributes[:category] = category unless category.nil?
      attributes[:eco_risk] = eco_risk unless eco_risk.nil?
      attributes[:external_id] = attributes[:external_id]&.to_i

      attributes
    end

    def create_or_update_ecoregion(attributes)
      ecoregion = Ecoregion.find_by(external_id: attributes[:external_id])

      if ecoregion
        ecoregion.update(attributes.compact)
        ecoregion.save
      else
        ecoregion = Ecoregion.find_by(name: attributes[:name])

        if ecoregion
          ecoregion.update(attributes.compact)
          ecoregion.save
        else
          ecoregion = Ecoregion.create(attributes)
        end
      end

      ecoregion
    end
  end
end
