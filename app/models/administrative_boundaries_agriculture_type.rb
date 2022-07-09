class AdministrativeBoundariesAgricultureType < ApplicationRecord
  include AgricultureType

  belongs_to :country
  belongs_to :administrative_boundary

  has_many :representative_agri_indicators, class_name: 'AgriIndicator', foreign_key: 'star_representative_id'
  has_many :min_agri_indicators, class_name: 'AgriIndicator', foreign_key: 'star_min_id'
  has_many :max_agri_indicators, class_name: 'AgriIndicator', foreign_key: 'star_max_id'

  validates :star_agriculture, numericality: true, allow_nil: true
  validates :star_all, numericality: true, allow_nil: true
end
