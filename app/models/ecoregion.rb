class Ecoregion < ApplicationRecord
  CATEGORIES = %w[
    A
    B
    C
    D
    E
    U
  ].freeze

  validates_presence_of :name
  validates_uniqueness_of :name
  validates :category, inclusion: { in: CATEGORIES, allow_nil: true }
  validates :eco_risk, numericality: { allow_nil: true }

  has_many :representative_agri_indicators, class_name: 'AgriIndicator', foreign_key: 'eco_risk_representative_id'
  has_many :min_agri_indicators, class_name: 'AgriIndicator', foreign_key: 'eco_risk_min_id'
  has_many :max_agri_indicators, class_name: 'AgriIndicator', foreign_key: 'eco_risk_max_id'

  has_many :mine_indicators
end
