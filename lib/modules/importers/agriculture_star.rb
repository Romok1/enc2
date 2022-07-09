module Importers
  class AgricultureStar < AgricultureBase
    COLUMNS = %w[
      agriculture_type
      iso_3
      representative_administrative_boundary_id
      representative_administrative_boundary_name
      representative_administrative_boundary_total_star_per_ha
      representative_administrative_boundary_agriculture_star_per_ha
      max_administrative_boundary_id
      max_administrative_boundary_total_star_per_ha
      max_administrative_boundary_agriculture_star_per_ha
      max_administrative_boundary_name
      min_administrative_boundary_id
      min_administrative_boundary_total_star_per_ha
      min_administrative_boundary_agriculture_star_per_ha
      min_administrative_boundary_name
    ].freeze

    REQUIRED_COLUMNS = %w[
      agriculture_type
      iso_3
      representative_administrative_boundary_id
      representative_administrative_boundary_name
      representative_administrative_boundary_total_star_per_ha
      representative_administrative_boundary_agriculture_star_per_ha
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
            create_or_update_agri_indicator_and_administrative_boundaries(row)
          end
        end
      end
    end

    private

    def create_or_update_agri_indicator_and_administrative_boundaries(row)
      agri_indicator = find_or_create_agri_indicator(row)
      attributes = {}

      # create & set the min/max eco_risk & star administrative_boundary relations
      %i[min max representative].each do |administrative_boundary_type|
        join_attributes = generate_administrative_boundaries_agriculture_type_attributes({
          administrative_boundary_type: administrative_boundary_type,
          row: row
        })

        attributes["star_#{administrative_boundary_type}".to_sym] =
          create_administrative_boundaries_agriculture_type!(join_attributes)
      end

      agri_indicator.update(attributes)
      agri_indicator.save!
    end

    def generate_administrative_boundaries_agriculture_type_attributes(
      administrative_boundary_type:,
      row:
    )
      {
        country_id: row['country_id'],
        agriculture_type: sanitize_agriculture_type(row['agriculture_type']),
        star_agriculture: row["#{administrative_boundary_type}_administrative_boundary_agriculture_star_per_ha"],
        star_all: row["#{administrative_boundary_type}_administrative_boundary_total_star_per_ha"],
        administrative_boundary: {
          name: row["#{administrative_boundary_type}_administrative_boundary_name"],
          external_id: row["#{administrative_boundary_type}_administrative_boundary_id"],
          country_id: row['country_id']
        }
      }
    end

    def create_administrative_boundaries_agriculture_type!(attributes)
      return nil unless attributes.values.all? { |value| !value.nil? }

      administrative_boundary_attributes =
        sanitize_administrative_boundary_attributes(attributes[:administrative_boundary])

      return nil unless administrative_boundary_attributes.values.all? { |value| !value.nil? }

      administrative_boundary =
        create_or_update_administrative_boundary(administrative_boundary_attributes)


      administrative_boundaries_agriculture_type = AdministrativeBoundariesAgricultureType.find_or_create_by!({
        agriculture_type: attributes[:agriculture_type],
        country_id: attributes[:country_id],
        administrative_boundary_id: administrative_boundary.id
      }) do |object|
        object.star_agriculture = attributes[:star_agriculture]&.to_d
        object.star_all = attributes[:star_all]&.to_d
      end
    end

    def create_or_update_administrative_boundary(attributes)
      administrative_boundary = AdministrativeBoundary.find_by(external_id: attributes[:external_id])
      if administrative_boundary
        administrative_boundary.update(attributes.compact)
        administrative_boundary.save
      else
        administrative_boundary = AdministrativeBoundary.find_by(name: attributes[:name])
        if administrative_boundary
          administrative_boundary.update(attributes.compact)
          administrative_boundary.save
        else
          administrative_boundary = AdministrativeBoundary.create!(attributes)
        end
      end
      administrative_boundary
    end

    def sanitize_administrative_boundary_attributes(attributes)
      attributes[:name] = attributes[:name]&.strip
      attributes[:external_id] = attributes[:external_id]&.strip

      attributes
    end
  end
end
