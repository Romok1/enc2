class Driver < ApplicationRecord
  has_many :assets_drivers_joins
  has_many :assets, through: :assets_drivers_joins
  has_and_belongs_to_many :impact_drivers, -> { distinct }
  
  validates :name, uniqueness: true
  
  has_many :national_resources, as: :mappable

  has_many :datasets_items_joins, as: :mappable
  has_many :datasets, through: :datasets_items_joins

  translates :name, :description, :data_needs
  
  include RatingHelper

  def ecosystem_services
    assets    = self.assets.uniq
    assets.map(&:ecosystem_services).flatten.uniq
  end

  def aggregated_assets_drivers_joins
    self.assets.uniq.map do |a|
      AssetsDriversJoin.where("asset_id = ? AND driver_id = ?", a.id, self.id).first
    end
  end
end
