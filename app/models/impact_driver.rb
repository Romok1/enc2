class ImpactDriver < ApplicationRecord
  validates :name, uniqueness: true

  has_many :impacts
  has_many :production_processes, through: :impacts
  has_and_belongs_to_many :drivers, -> { distinct }

  has_many :datasets_items_joins, as: :mappable
  has_many :datasets, through: :datasets_items_joins

  translates :name, :description

  include RatingHelper

  def to_formatted_json(flatten_assets=true)
    self.as_json(
      :include => {
        :sorted_impacts => {
          :only => [:id, :name, :rag, :justification],
          :include => {
            :production_process => {
              :only => [:id, :name]
            }
          }
        },
        :drivers => ( {
                        :only => [:id, :name],
                        :include => {
                          :assets => {
                            :only => [:id, :name]
                          }
                        }
                      } if !flatten_assets
                    ),
        :unique_assets => ( {
                              :only => [:id, :name]
                            } if flatten_assets
                          )
      }.compact
    )
  end

  # Get the unique assets that this imapcts (through drivers_
  def unique_assets
    drivers.map{|d| d.assets}.flatten.uniq
  end

  def sorted_impacts
    self.impacts.sort{|a,b| compare_rating(a,b) }
  end
  
end
