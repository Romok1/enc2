module BiodiversityGoals::MiningDashboard
  module Indicators
    def self.count_mines(param)
      return MineIndicator.count if param.first['company_id'].empty? && param.first['locations'].empty?

      query = <<~SQL
        SELECT COUNT(*)
        FROM (
          #{retrieve_mine_indicators_query(param)}
        ) t
      SQL

      ActiveRecord::Base.connection.execute(query).first['count']
    end

    def self.fetch_indicators(params)
      if params.first['locations'].present? || params.first['company_id'].present?
        <<~SQL
          SELECT *
          FROM (
            #{retrieve_mine_indicators_query(params)}
          ) t
        SQL
      else
        base_statement
      end
    end

    # The UNION is used to join queries to take into account multiple forms,
    # and so multiple company/countries combination. UNION has been preferred to
    # OR for the sake of code readability
    def self.retrieve_mine_indicators_query(params)
      subquery = []
      params.each do |param|
        subquery << retrieve_mine_indicators_subquery(param)
      end
      subquery.join(' UNION ')
    end

    def self.retrieve_mine_indicators_subquery(param)
      return retrieve_mine_indicators_by_country_query(param) if param['company_id'].blank?
      return retrieve_mine_indicators_by_company_query(param) if param['locations'].blank?

      countries_id = Country.where(iso_3: param['locations']).pluck(:id)
      retrieve_mine_indicators_by_company_query(param) + "AND mi.country_id IN (#{countries_id.join(',')})"
    end

    def self.retrieve_mine_indicators_by_country_query(param)
      countries_id = Country.where(iso_3: param['locations']).pluck(:id)
      <<~SQL
        #{base_statement}
        WHERE mi.country_id IN (#{countries_id.join(',')})
      SQL
    end

    # TODO: when ecoregion names are translated,
    # queries like this may need to be updated if the ecoregion name is used
    def self.retrieve_mine_indicators_by_company_query(param)
      <<~SQL
        #{base_statement}
        INNER JOIN mines_companies_joins mcj ON mcj.mine_indicator_id = mi.id
        WHERE mcj.company_id = #{param['company_id']}
      SQL
    end

    def self.base_statement
      <<~SQL
        SELECT DISTINCT
          mi.mine_id,
          mi.mineral_id,
          mi.eco_risk,
          mi.star_all_threat,
          mi.star_mining_threat,
          e.category AS ecoregion_category,
          ab.name AS administrative_boundary_name,
          ab.id AS administrative_boundary_id,
          ct.name AS country_name
        FROM mine_indicators mi
        INNER JOIN ecoregions e ON e.id = mi.ecoregion_id
        INNER JOIN administrative_boundaries ab ON mi.administrative_boundary_id = ab.id
        INNER JOIN country_translations ct ON ct.country_id = mi.country_id
      SQL
    end
  end
end
