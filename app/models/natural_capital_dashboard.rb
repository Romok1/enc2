class NaturalCapitalDashboard
  def self.overview(
    production_process_ids: [],
    sub_industry_ids: []
  )
    {
      production_processes: ProductionProcess.where(id: production_process_ids),
      sub_industries: SubIndustry.where(id: sub_industry_ids)
    }
  end
end
