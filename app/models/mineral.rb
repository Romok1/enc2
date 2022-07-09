class Mineral < ApplicationRecord
  has_many :mine_indicators, dependent: :destroy
  has_many :references, class_name: 'MineralReference', dependent: :destroy

  translates :name, :justification

  enum is_aligned: {
    true: 'true',
    false: 'false',
    not_assessed: 'not assessed'
  }
end
