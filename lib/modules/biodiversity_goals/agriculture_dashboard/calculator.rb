module BiodiversityGoals::AgricultureDashboard
  class Calculator
    include BiodiversityGoals::CalculatorHelper

    def self.calculate_indicators(params)
      new.calculate_indicators(params)
    end

    def calculate_indicators(params)
      @star_agriculture = 0.0
      @star_all = 0.0
      @ecoregion_categories = Ecoregion::CATEGORIES.map { |cat| [cat.to_sym, 0] }.to_h
      @ecoregions_agriculture_types = []
      @administrative_boundaries_agriculture_types = []
      @agriculture_types = Set[]
      @portfolio_area = 0.0

      add_data_for_params(params)

      {
        agriculture_types: @agriculture_types,
        ecoregions_agriculture_types: @ecoregions_agriculture_types,
        administrative_boundaries_agriculture_types: @administrative_boundaries_agriculture_types,
        eco_risk: eco_risk,
        star_agriculture: @star_agriculture,
        star_all: @star_all,
        ecoregion_categories: ecoregion_categories,
        star_comparison_to_average: star_comparison_to_average,
        eco_risk_comparison_to_average: eco_risk_comparison_to_average,
      }
    end

    private

    def add_data_for_params(params)
      params.each do |param|
        country = Country.find_by(iso_3: param[:country])

        country.agri_indicators.each do |agri_indicator|
          area = area_calculation(param, agri_indicator)
          next unless area.positive?

          @agriculture_types.add(agri_indicator.agriculture_type)
          @portfolio_area += area
          add_risk_to_totals(agri_indicator, area)

          %i[min max representative].each do |region_relation|
            ecoregions_agriculture_type = ecoregions_agriculture_type(
              country: country,
              region_relation: region_relation,
              agri_indicator: agri_indicator,
              area: area
            )

            administrative_boundaries_agriculture_type = administrative_boundaries_agriculture_type(
              country: country,
              region_relation: region_relation,
              agri_indicator: agri_indicator,
              area: area
            )

            @ecoregions_agriculture_types << ecoregions_agriculture_type unless ecoregions_agriculture_type.nil?

            unless administrative_boundaries_agriculture_type.nil?
              @administrative_boundaries_agriculture_types << administrative_boundaries_agriculture_type
            end
          end
        end
      end
    end

    def add_risk_to_totals(agri_indicator, area)
      add_star_risk_to_totals(agri_indicator, area)
      add_eco_risk_to_categories(agri_indicator, area)
    end

    def add_eco_risk_to_categories(agri_indicator, area)
      representative_ecoregion = agri_indicator.eco_risk_representative

      return if representative_ecoregion.nil? || representative_ecoregion.eco_risk.blank?

      @ecoregion_categories[representative_ecoregion.category.to_sym] +=
        area * representative_ecoregion.eco_risk
    end

    def add_star_risk_to_totals(agri_indicator, area)
      representative_administrative_boundary = agri_indicator.star_representative

      return if representative_administrative_boundary.nil?

      @star_agriculture += area * representative_administrative_boundary.star_agriculture
      @star_all += area * representative_administrative_boundary.star_all
    end

    # Leaving this in as it may be used in future updates when alighning with Post2020 goals
    # def star_percentage_of_sector
    #   @star_all / estimated_global_total_star_all * 100
    # end

    # def estimated_global_total_star_all
    #   AgriIndicator.where.not(total_star_all: nil).sum(&:total_star_all)
    # end

    def star_comparison_to_average
      humanize_comparison_to_average(
        comparison_to_average(
          portfolio_average: portfolio_star_all_per_ha,
          sector_average: sector_avg_star_all_per_ha
        )
      )
    end

    def eco_risk_comparison_to_average
      humanize_comparison_to_average(
        comparison_to_average(
          portfolio_average: portfolio_eco_risk_per_ha,
          sector_average: sector_avg_eco_risk_per_ha
        )
      )
    end

    def sector_avg_star_all_per_ha
      representative_administrative_boundary_agriculture_types =
        AgriIndicator.all.map(&:star_representative).compact

        representative_administrative_boundary_agriculture_types.sum(&:star_all) / representative_administrative_boundary_agriculture_types.count
    end

    def sector_avg_eco_risk_per_ha
      representative_ecoregions = 
        AgriIndicator.all.map(&:eco_risk_representative).compact

      representative_ecoregions.sum(&:eco_risk) / representative_ecoregions.count
    end

    def portfolio_star_all_per_ha
      @star_all / @portfolio_area
    end

    def portfolio_eco_risk_per_ha
      eco_risk / @portfolio_area
    end

    def ecoregion_categories
      ecoregion_categories = @ecoregion_categories.keys.map do |category|
        if category == :U && ecoregion_category_percentage(category).zero?
          nil
        else
          {
            category: category.to_s,
            percentage: ecoregion_category_percentage(category).round(1)
          }
        end
      end

      ecoregion_categories.compact
    end

    def ecoregion_category_percentage(category)
      return 0 if eco_risk.zero?

      @ecoregion_categories[category] / eco_risk * 100
    end

    def eco_risk
      @ecoregion_categories.values.sum
    end

    def ecoregions_agriculture_type(country:, region_relation:, agri_indicator:, area:)
      ecoregion = agri_indicator.send("eco_risk_#{region_relation}") || agri_indicator.eco_risk_representative

      return nil if ecoregion.nil?

      {
        country_name: country.name,
        ecoregion_name: ecoregion.name,
        ecoregion_category: ecoregion.category,
        region_relation: region_relation,
        agriculture_type: agri_indicator.agriculture_type,
        eco_risk: area * ecoregion.eco_risk
      }
    end

    def administrative_boundaries_agriculture_type(country:, region_relation:, agri_indicator:, area:)
      administrative_boundary_agriculture_type = agri_indicator.send("star_#{region_relation}") ||
        agri_indicator.star_representative

      return nil if administrative_boundary_agriculture_type.nil?

      administrative_boundary = administrative_boundary_agriculture_type.administrative_boundary

      {
        country_name: country.name,
        administrative_boundary_name: administrative_boundary.name,
        region_relation: region_relation,
        agriculture_type: agri_indicator.agriculture_type,
        star_all_threats: area * administrative_boundary_agriculture_type.star_all
      }
    end

    def area_calculation(param, agri_indicator)
      agriculture_type = agri_indicator.agriculture_type
      area_type = param["#{agriculture_type}_area_type".to_sym]
      value = param["#{agriculture_type}_value".to_sym].to_f
      area_to_turnover_ratio = agri_indicator.area_to_turnover_ratio || 0

      if area_type == 'turnover'
        # turnover in dollars in db while user input million of dollars
        value * area_to_turnover_ratio * 1e6
      else
        value
      end
    end

    # def agricuture_area_value(param, agri_indicator)
    #   agriculture_type = agri_indicator.agriculture_type

    #   param["#{agriculture_type}_value".to_sym].to_f
    # end
  end
end
