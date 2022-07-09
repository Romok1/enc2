class SubIndustryProductionProcessJoin < ApplicationRecord
  belongs_to :sub_industry
  belongs_to :production_process
end
