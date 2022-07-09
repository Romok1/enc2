module AgricultureType
  extend ActiveSupport::Concern

  TYPES = %i[
    crops
    livestock
  ].freeze

  included do
    # expands TYPES into hash with names as keys & index as value
    enum agriculture_type: Hash[TYPES.map.with_index { |i, v| [i, v] }]
  end
end
