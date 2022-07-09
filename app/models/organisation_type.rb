# Currently used in association with user's "Organisation" field
class OrganisationType < ApplicationRecord
  has_many :alignment_options_organisation_types_joins, dependent: :destroy
  has_many :alignment_options, through: :alignment_options_organisation_types_joins
  has_many :users

  # @see https://github.com/globalize/globalize
  translates :name, touch: true, fallbacks_for_empty_translations: true

  validates_presence_of :name
  validates_uniqueness_of :name
end
