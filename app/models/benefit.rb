class Benefit < ApplicationRecord
  has_many :benefits_ecosystem_services_joins
  has_many :ecosystem_services, through: :benefits_ecosystem_services_joins
  validates :name, uniqueness: true
  translates :name
end
