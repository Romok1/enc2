class Asset < ApplicationRecord
  has_many :ecosystem_services_assets_joins
  has_many :ecosystem_services, through: :ecosystem_services_assets_joins

  has_many :assets_drivers_joins
  has_many :drivers, through: :assets_drivers_joins

  has_many :national_resources, as: :mappable

  has_many :datasets_items_joins, as: :mappable
  has_many :datasets, through: :datasets_items_joins

  validates :name, uniqueness: true

  translates :name, :description, :data_needs

  include RatingHelper

  def materialities
    unique_materialities_from_services(self.ecosystem_services)
  end

  def to_formatted_json include = "es"
    self.as_json(
      :include => {
        :ecosystem_services  =>
        ( {
            :only => [:id, :name, :category, :category_description, :description], :include => {
              :sorted_materialities => {
                :only => [:id, :rag, :justification], :include => {
                  :production_process => {:only => [:id, :name] }
                }
              }
            }
          } if include == "es"
        ),
        :impact_drivers =>
        ( {
            :only => [:id, :name, :description], :include => {
                        :sorted_impacts => {
                          :only => [:id, :rag, :justification],
                          :include => {
                            :production_process => {
                              :only => [:id, :name]
                            }
                          }
              }
            }
          } if include == "id"
        )
      }.compact
    )
  end

  def impact_drivers
    drivers.map{|d| d.impact_drivers}.flatten.uniq
  end
end
