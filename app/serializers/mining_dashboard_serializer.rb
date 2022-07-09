# frozen_string_literal: true

class MiningDashboardSerializer < BaseSerializer
  include NumberHelper

  GLOBAL_LEGEND = [
    {
      name: I18n.t('serializers.mining_dashboard.labels.sector_average'),
      type: 'thick-solid'
    },
    {
      name: I18n.t('serializers.mining_dashboard.labels.your_portfolio_average'),
      type: 'thin-dotted'
    },
    {
      name: I18n.t('serializers.mining_dashboard.labels.your_portfolio_range'),
      type: 'thin-dashed'
    }
  ].freeze

  SCENARIO_LEGEND = [
    {
      name: I18n.t('serializers.mining_dashboard.labels.commodity_range'),
      type: 'thin-dashed'
    },
    {
      name: I18n.t('serializers.mining_dashboard.labels.commodity_average'),
      type: 'thin-dotted'
    }
  ].freeze

  def serialize
    {
      alignmentOptions: data[:alignment_options],
      exposureResults: exposure_results,
      globalOverview: global_overview,
      futureExposureScenarios: future_exposure_scenarios
    }
  end

  private

  def exposure_results
    {
      star: {
        allThreats: round_sensibly_to_string(data[:star_all]),
        sectorThreats: round_sensibly_to_string(data[:star_mining]),
        otherThreats: round_sensibly_to_string(data[:star_all] - data[:star_mining]),
        sectorPercentage: friendly_small_number(data[:star_sector_percentage]),
        comparisonToAverage: data[:star_comparison_to_average]
      },
      ecoIntegrityRisk: {
        allThreats: round_sensibly_to_string(data[:eco_risk]),
        sectorPercentage: friendly_small_number(data[:eco_sector_percentage]),
        comparisonToAverage: data[:eco_comparison_to_average],
        ecoregionCategories: data[:eco_ecoregion_categories]
      }
    }
  end

  def global_overview
    {
      averages: {
        star: star_global,
        ecoIntegrityRisk: eco_global
      },
      ecoregions: ecoregions,
      administrativeBoundaries: administrative_boundaries
    }
  end

  def ecoregions
    sorted_ecoregions = data[:ecoregions].sort_by do |e|
      [
        -e[:eco_risk],
        -e[:category].ord, # sorting by reverse category (e -> a)
        e[:countries][0],
        e[:name]
      ]
    end

    sorted_ecoregions.map do |ecoregion|
      {
        id: ecoregion[:id],
        name: ecoregion[:name],
        category: ecoregion[:category].downcase,
        ecoIntegrityRisk: round_eco_risk_to_string(ecoregion[:eco_risk]),
        countries: ecoregion[:countries]
      }
    end
  end

  def administrative_boundaries
    sorted_administrative_boundaries = data[:administrative_boundaries]
      .sort_by { |ab| [-ab[:star], ab[:country], ab[:name]] }

    sorted_administrative_boundaries.map do |administrative_boundary|
      {
        id: administrative_boundary[:id],
        name: administrative_boundary[:name],
        star: round_sensibly_to_string(administrative_boundary[:star]),
        country: administrative_boundary[:country]
      }
    end
  end

  def star_global
    {
      min: shifted_log(data['mine_sector_star_min']),
      max: shifted_log(data['mine_sector_star_max']),
      markers: markers('star'),
      legend: GLOBAL_LEGEND
    }
  end

  def eco_global
    {
      min: round_eco_risk(data['mine_sector_eco_risk_min']),
      max: round_eco_risk(data['mine_sector_eco_risk_max']),
      markers: markers('eco_risk'),
      legend: GLOBAL_LEGEND
    }
  end

  def markers(type)
    [
      {
        name: I18n.t('serializers.mining_dashboard.labels.sector_average'),
        type: 'thick-solid',
        value: risk_value(data["mine_sector_#{type}_avg"], type)
      },
      {
        name: I18n.t('serializers.mining_dashboard.labels.porfolio_min'),
        type: 'thin-dashed',
        value: risk_value(data["#{type}_min".to_sym], type)
      },
      {
        name: I18n.t('serializers.mining_dashboard.labels.portfolio_max'),
        type: 'thin-dashed',
        value: risk_value(data["#{type}_max".to_sym], type)
      },
      {
        name: I18n.t('serializers.mining_dashboard.labels.portfolio_average'),
        type: 'thin-dotted',
        value: risk_value(data["#{type}_avg".to_sym], type)
      }
    ]
  end

  def future_exposure_scenarios
    data[:minerals].sort_by(&:name)
      .map do |mineral|
        {
          id: mineral.id,
          mineral: mineral.name,
          justification: mineral.justification,
          references: mineral.references,
          alignment: alignment(mineral.is_aligned),
          star: build_scenario(mineral, 'star'),
          ecoIntegrityRisk: build_scenario(mineral, 'eco_risk')
        }
      end
  end

  def alignment(is_aligned)
    case is_aligned
    when 'false'
      'not_supporting'
    when 'true'
      'supporting'
    else
      'not_assessed'
    end
  end

  def build_scenario(mineral, type)
    min = data["mineral_sector_#{type}_min"]
    max = data["mineral_sector_#{type}_max"]

    {
      id: type.to_s,
      min: risk_value(min, type),
      max: risk_value(max, type),
      markers: scenario_markers(mineral, type),
      legend: SCENARIO_LEGEND
    }
  end

  def scenario_markers(mineral, type)
    [
      {
        name: 'commodityAverage',
        type: 'thin-dotted',
        value: risk_value(mineral.send("#{type}_avg"), type)
      },
      {
        name: 'commodityMin',
        type: 'thin-dashed',
        value: risk_value(mineral.send("#{type}_min"), type)
      },
      {
        name: 'commodityMax',
        type: 'thin-dashed',
        value: risk_value(mineral.send("#{type}_max"), type)
      }
    ]
  end

  def risk_value(number, type)
    type == 'star' ? shifted_log(number) : round_eco_risk(number)
  end

  def shifted_log(number, precision = 1)
    Math.log(1 + number).to_f.round(precision)
  end
end
