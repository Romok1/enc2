class Region < ApplicationRecord
  has_many :countries

  translates :name
end
