class Ecosystem < ApplicationRecord
  has_many :datasets_items_joins, as: :mappable
  has_many :datasets, through: :datasets_items_joins

  translates :name
end
