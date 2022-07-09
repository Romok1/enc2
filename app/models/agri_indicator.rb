class AgriIndicator < ApplicationRecord
  include AgricultureType

  belongs_to :country

  belongs_to :eco_risk_representative, class_name: 'Ecoregion', optional: true
  belongs_to :eco_risk_min, class_name: 'Ecoregion', optional: true
  belongs_to :eco_risk_max, class_name: 'Ecoregion', optional: true
  belongs_to :star_representative, class_name: 'AdministrativeBoundariesAgricultureType', optional: true
  belongs_to :star_min, class_name: 'AdministrativeBoundariesAgricultureType', optional: true
  belongs_to :star_max, class_name: 'AdministrativeBoundariesAgricultureType', optional: true

  validates :area_to_turnover_ratio, numericality: true, allow_nil: true
end
