class AdministrativeBoundary < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :external_id
  validates_uniqueness_of :external_id

  belongs_to :country

  has_many :agri_indicators, through: :administrative_boundaries_agriculture_types
  has_many :mine_indicators
end
