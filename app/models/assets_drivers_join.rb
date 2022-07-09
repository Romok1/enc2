class AssetsDriversJoin < ApplicationRecord
  belongs_to :asset
  belongs_to :driver
  translates :justification, :likely_response, :effect_on_variability, :human_action_or_natural_variation, :timescale, :spatial_characteristics
end
