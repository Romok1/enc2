class SubIndustry < ApplicationRecord
  belongs_to :sector

  has_many :sub_industry_production_process_joins
  has_many :production_processes, through: :sub_industry_production_process_joins

  validates :name, uniqueness: true
  translates :name

  def to_formatted_json
    as_json(
      only: %i[id name],
      include: {
        production_processes: { only: %i[id name] }
      }
    )
  end
end
