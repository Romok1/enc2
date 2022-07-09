class EcosystemService < ApplicationRecord
  has_many :materialities
  has_many :production_processes, through: :materialities

  has_many :ecosystem_services_assets_joins
  has_many :assets, through: :ecosystem_services_assets_joins

  has_many :benefits_ecosystem_services_joins
  has_many :benefits, through: :benefits_ecosystem_services_joins

  validates :name, uniqueness: true

  translates :name, :description, :category, :category_description, :url

  scope :grouped_by_rag, ->(rag) { joins(:materialities).where(materialities: { rag: rag }).uniq }

  include RatingHelper

  def sorted_materialities
    self.materialities.sort{|a,b| compare_rating(a,b) }
  end

  def production_process_by_materiality(rag)
    ids = materialities.where("materialities.rag = '#{rag}'").pluck(:production_process_id)
    ProductionProcess.find(ids).pluck(:name)
  end

  def to_formatted_json
    self.as_json(
      :include => {
        :assets => {
          :only => [:id, :name]
        },
        :sorted_materialities => {
          :only => [:id, :rag, :justification],
          :include => {
            :production_process => {
              :only => [:id, :name]
            }
          }
        }
      }
    )
  end
end
