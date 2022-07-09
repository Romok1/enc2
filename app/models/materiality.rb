class Materiality < ApplicationRecord
  belongs_to :production_process
  belongs_to :ecosystem_service

  has_many :impacts, through: :production_process

  translates :justification
end
