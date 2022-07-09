class NationalResource < ApplicationRecord
  belongs_to :mappable, polymorphic: true
end
