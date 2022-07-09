class Impact < ApplicationRecord
  belongs_to :production_process
  belongs_to :impact_driver

  translates :justification
end
