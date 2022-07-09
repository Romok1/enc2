# frozen_string_literal: true

class AgricultureDashboardSerializer < BaseSerializer
  include NumberHelper

  def serialize
    {
      globalOverview: {
        ecoregions: global_overview_ecoregions,
        administrativeBoundaries: global_overview_administrative_boundaries
      },
      alignmentOptions: data[:alignment_options],
      exposureResults: {
        star: exposure_results_star,
        ecoIntegrityRisk: exposure_results_eco_integrity_risk
      }
    }
  end

  private

  def exposure_results_star
    return nil if data[:star_all].zero?

    {
      sectorThreats: round_sensibly_to_string(data[:star_agriculture]),
      allThreats: round_sensibly_to_string(data[:star_all]),
      otherThreats: round_sensibly_to_string(data[:star_all] - data[:star_agriculture]),
      comparisonToAverage: data[:star_comparison_to_average]
    }
  end

  def exposure_results_eco_integrity_risk
    return nil if data[:eco_risk].zero?

    {
      allThreats: round_eco_risk_to_string(data[:eco_risk]),
      ecoregionCategories: data[:ecoregion_categories],
      comparisonToAverage: data[:eco_risk_comparison_to_average]
    }
  end

  def global_overview_ecoregions
    # Note we're sorting by reverse category (E -> A)
    regions_agriculture_types = data[:ecoregions_agriculture_types]
      .sort_by do |e|
        [
          -e[:eco_risk],
          e[:country_name],
          -e[:ecoregion_category].ord,
          e[:ecoregion_name]
        ]
      end

    {
      filters: {
        agricultureType: agriculture_type_filter,
        ecoregion: region_type_filter
      },
      regionsAgricultureTypeJoin:
        serialize_ecoregions_agriculture_types(regions_agriculture_types)
    }
  end

  def serialize_ecoregions_agriculture_types(regions_agriculture_types)
    regions_agriculture_types.map do |ecoregions_agriculture_type|
      {
        country: ecoregions_agriculture_type[:country_name],
        agricultureType: {
          filterValue: ecoregions_agriculture_type[:agriculture_type],
          name: agriculture_type_translation(ecoregions_agriculture_type[:agriculture_type])
        },
        ecoregion: {
          name: ecoregions_agriculture_type[:ecoregion_name],
          category: ecoregions_agriculture_type[:ecoregion_category].downcase,
          filterValue: ecoregions_agriculture_type[:region_relation]
        },
        ecoIntegrityRisk: round_eco_risk_to_string(ecoregions_agriculture_type[:eco_risk])
      }
    end
  end

  def global_overview_administrative_boundaries
    regions_agriculture_types = data[:administrative_boundaries_agriculture_types]
      .sort_by do |rats|
        [
          -rats[:star_all_threats],
          rats[:country_name],
          rats[:administrative_boundary_name]
        ]
      end

    {
      filters: {
        agricultureType: agriculture_type_filter,
        administrativeBoundary: region_type_filter
      },
      regionsAgricultureTypeJoin:
        serialize_administrative_boundaries_agriculture_types(regions_agriculture_types)
    }
  end

  def serialize_administrative_boundaries_agriculture_types(administrative_boundaries_agriculture_types)
    administrative_boundaries_agriculture_types.map do |administrative_boundaries_agriculture_type|
      {
        country: administrative_boundaries_agriculture_type[:country_name],
        agricultureType: {
          filterValue: administrative_boundaries_agriculture_type[:agriculture_type],
          name: agriculture_type_translation(administrative_boundaries_agriculture_type[:agriculture_type])
        },
        administrativeBoundary: {
          name: administrative_boundaries_agriculture_type[:administrative_boundary_name],
          filterValue: administrative_boundaries_agriculture_type[:region_relation]
        },
        star: round_sensibly_to_string(administrative_boundaries_agriculture_type[:star_all_threats])
      }
    end
  end

  def region_type_filter
    %w[representative min max].map do |id|
      {
        id: id,
        name: translation("components.global_overview.table.filters.regionType.#{id}")
      }
    end
  end

  def agriculture_type_filter
    agriculture_types = data[:agriculture_types].to_a

    return nil if agriculture_types.count < 2

    (['all'] + agriculture_types).map do |id|
      {
        id: id,
        name: agriculture_type_translation(id)
      }
    end
  end

  def agriculture_type_translation(agriculture_type)
    translation("components.global_overview.table.filters.agricultureType.#{agriculture_type}")
  end

  def translation(path = nil)
    path = ".#{path}" unless path.nil?

    I18n.t("biodiversity_goals.dashboard.agriculture#{path}")
  end
end
