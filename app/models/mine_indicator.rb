class MineIndicator < ApplicationRecord
  belongs_to :country
  belongs_to :mineral
  belongs_to :ecoregion
  belongs_to :administrative_boundary

  has_many :mines_companies_joins, dependent: :destroy
  has_many :companies, through: :mines_companies_joins

  validates_uniqueness_of :mine_id
end
