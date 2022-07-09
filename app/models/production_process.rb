class ProductionProcess < ApplicationRecord
  has_many :sub_industry_production_process_joins
  has_many :sub_industries, through: :sub_industry_production_process_joins

  has_many :materialities
  has_many :ecosystem_services, through: :materialities

  has_many :impacts
  has_many :impact_drivers, through: :impacts

  validates :name, uniqueness: true
  translates :name

  scope(
    :sub_industry_production_process_filter,
    lambda do |sub_industry_ids|
      joins(:sub_industry_production_process_joins)
        .where(
          sub_industry_production_process_joins: {
            sub_industry_id: sub_industry_ids
          }
        ).uniq
    end
  )

  def to_formatted_json
    as_json(
      only: %i[id name],
      include: {
        materialities: { only: %i[id rag justification] }
      }
    )
  end
end
