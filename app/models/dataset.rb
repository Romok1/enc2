class Dataset < ApplicationRecord
  has_many :datasets_items_joins

  has_many :assets,   through: :datasets_items_joins, :source => :mappable, :source_type => 'Asset'
  has_many :drivers,  through: :datasets_items_joins, :source => :mappable, :source_type => 'Driver'
  has_many :impact_drivers,  through: :datasets_items_joins, :source => :mappable, :source_type => 'ImpactDriver'

  translates :name, :description
end
