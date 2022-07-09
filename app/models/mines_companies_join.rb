class MinesCompaniesJoin < ApplicationRecord
  belongs_to :mine_indicator
  belongs_to :company

  enum relationship: {
    owner: 'owner',
    operator: 'operator'
  }
end
