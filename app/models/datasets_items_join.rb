class DatasetsItemsJoin < ApplicationRecord
  belongs_to :dataset
  belongs_to :mappable, polymorphic: true
end
