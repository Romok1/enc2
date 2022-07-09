class AlignmentOption < ApplicationRecord
  has_many :alignment_options_organisation_types_joins, dependent: :destroy
  has_many :organisation_types, through: :alignment_options_organisation_types_joins

  validates_presence_of :description,
                        :biodiversity_module

  translates :description, :link

  enum biodiversity_module: {
    agriculture: 'agriculture',
    mining: 'mining'
  }
end
