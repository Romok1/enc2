class Country < ApplicationRecord
  belongs_to :region
  has_many :users, dependent: :nullify

  has_many :administrative_boundaries_agriculture_types, dependent: :destroy
  has_many :administrative_boundaries, through: :administrative_boundaries_agriculture_types
  has_many :agri_indicators, dependent: :destroy

  has_many :mine_indicators, dependent: :destroy

  scope :with_agriculture_countries, -> { where('iso_3 IN ( SELECT iso_3 FROM agri_countries_view )') }

  translates :name

  def to_s
    iso_3
  end
end
