module BiodiversityGoals::MiningDashboard
  class Calculator
    include BiodiversityGoals::CalculatorHelper

    def self.calculate_indicators(params, ecoregions)
      new(params, ecoregions).calculate_indicators
    end

    def calculate_indicators
      @is_whole_sector = @forms.count == 1 && @forms[0]['company_id'].blank?

      @indicator_aggregate_results = MineIndicator.find_by_sql(Indicators.fetch_indicators(@forms))

      @mines_count += @indicator_aggregate_results.count

      return {} if @mines_count.zero?

      @indicator_aggregate_results.each do |row|
        @star_mining += row.star_mining_threat
        @star_all += row.star_all_threat
        @eco_risk += row.eco_risk

        # porfolio min and max
        @star_min = row.star_all_threat if row.star_all_threat < @star_min
        @star_max = row.star_all_threat if row.star_all_threat > @star_max
        @eco_risk_min = row.eco_risk if row.eco_risk < @eco_risk_min
        @eco_risk_max = row.eco_risk if row.eco_risk > @eco_risk_max

        @eco_ecoregion_categories[row.ecoregion_category.to_sym] += row.eco_risk

        # future exposure scenarios
        @future_exposure_minerals.add(row.mineral)

        unless @is_whole_sector
          add_or_update_administrative_boundary!(
            id: row.administrative_boundary_id,
            name: row.administrative_boundary_name,
            star: row.star_all_threat,
            country: row.country_name
          )
        end
      end

      to_hash
    end

    private

    def initialize(params, ecoregions)
      @forms = params.map(&:stringify_keys)
      @ecoregions = ecoregions

      @star_mining = 0.0
      @star_all    = 0.0
      @star_min    = 1e10
      @star_max    = 0.0
      @eco_risk_min     = 1e10
      @eco_risk_max     = 0.0
      @eco_risk    = 0.0
      @mines_count = 0

      @future_exposure_minerals = Set[]
      @administrative_boundaries = []

      @eco_ecoregion_categories = Ecoregion::CATEGORIES.map { |cat| [cat.to_sym, 0] }.to_h
    end

    def to_hash
      {
        eco_risk: @eco_risk,
        eco_risk_min: @eco_risk_min,
        eco_risk_max: @eco_risk_max,
        eco_risk_avg: (@eco_risk / @mines_count),
        star_mining: @star_mining,
        star_all: @star_all,
        star_min: @star_min.to_f,
        star_max: @star_max.to_f,
        star_avg: (@star_all / @mines_count).to_f,
        minerals: @future_exposure_minerals,
        administrative_boundaries: @administrative_boundaries,
        ecoregions: ecoregions
      }
        .merge(mine_sector_stats)
        .merge(mineral_sector_stats)
        .merge(star_exposure_results)
        .merge(eco_exposure_results)
    end

    def ecoregions
      @ecoregions.map do |ecoregion|
        countries = ecoregion.mine_indicators
          .map { |mine_indicator| mine_indicator.country.name }
          .uniq
          .sort

        {
          id: ecoregion.id,
          name: ecoregion.name,
          category: ecoregion.category,
          eco_risk: ecoregion.mine_indicators.sum(&:eco_risk),
          countries: countries
        }
      end
    end

    def add_or_update_administrative_boundary!(
      id:,
      name:,
      star:,
      country:
    )
      existing_index = @administrative_boundaries.index { |administrative_boundary| administrative_boundary[:id] == id }

      if existing_index
        @administrative_boundaries[existing_index][:star] += star
      else
        @administrative_boundaries.push({
          id: id,
          name: name,
          star: star,
          country: country
        })
      end
    end

    def star_exposure_results
      {
        star_sector_percentage: star_percentage_of_sector,
        star_comparison_to_average: humanize_comparison_to_average(
          comparison_to_average(
            portfolio_average: star_portfolio_average,
            sector_average: star_sector_average
          )
        )
      }
    end

    def eco_exposure_results
      {
        eco_sector_percentage: eco_percentage_of_sector,
        eco_comparison_to_average: humanize_comparison_to_average(
          comparison_to_average(
            portfolio_average: eco_portfolio_average,
            sector_average: eco_sector_average
          )
        ),
        eco_ecoregion_categories: categories_percentages
      }
    end

    def eco_percentage_of_sector
      portfolio_total = @eco_risk
      sector_total = MineIndicator.sum(:eco_risk)
      portfolio_total / sector_total * 100
    end

    def eco_portfolio_average
      @eco_risk / @mines_count
    end

    def eco_sector_average
      MineIndicator.average(:eco_risk)
    end

    def star_percentage_of_sector
      portfolio_total = @star_all
      sector_total = MineIndicator.sum(:star_all_threat)
      portfolio_total / sector_total * 100
    end

    def star_portfolio_average
      @star_all / @mines_count
    end

    def star_sector_average
      MineIndicator.average(:star_all_threat)
    end

    def categories_percentages
      ecoregion_categories = @eco_ecoregion_categories.keys.map do |category|
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
      return 0 if @eco_risk.zero?

      @eco_ecoregion_categories[category] / @eco_risk * 100
    end

    def mine_sector_stats
      # TODO: add cache
      query = <<~SQL
        SELECT SUM(star_all_threat) AS mine_sector_star_global,
               AVG(star_all_threat) AS mine_sector_star_avg,
               MAX(star_all_threat) AS mine_sector_star_max,
               MIN(star_all_threat) AS mine_sector_star_min,
               SUM(eco_risk) AS mine_sector_eco_risk_global,
               AVG(eco_risk) AS mine_sector_eco_risk_avg,
               MAX(eco_risk) AS mine_sector_eco_risk_max,
               MIN(eco_risk) AS mine_sector_eco_risk_min
        FROM mine_indicators
      SQL

      res = ActiveRecord::Base.connection.execute(query).first
      res.transform_values(&:to_f)
    end

    def mineral_sector_stats
      # TODO: add cache
      query = <<~SQL
        SELECT SUM(star_avg) AS mineral_sector_star_global,
               MAX(star_max) AS mineral_sector_star_max,
               MIN(star_min) AS mineral_sector_star_min,
               SUM(eco_risk_avg) AS mineral_sector_eco_risk_global,
               MAX(eco_risk_max) AS mineral_sector_eco_risk_max,
               MIN(eco_risk_min) AS mineral_sector_eco_risk_min
        FROM minerals
      SQL

      res = ActiveRecord::Base.connection.execute(query).first
      res.transform_values(&:to_f)
    end
  end
end
