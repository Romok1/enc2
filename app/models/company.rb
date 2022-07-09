class Company < ApplicationRecord
  has_many :mines_companies_joins, dependent: :destroy
  has_many :mine_indicators, through: :mines_companies_joins

  scope :except_excluded_companies, ->{ where.not('name ~* ?', '[?®¿!¡]|^NA|^Unnamed') }
  scope :match_companies, ->(term) { where('LOWER(name) LIKE BTRIM(LOWER(:term))', term: "%#{term}%") }
end
