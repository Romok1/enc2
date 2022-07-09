class Sector < ApplicationRecord
  has_many :sub_industries, dependent: :destroy
  has_many :production_processes, through: :sub_industries
  validates :name, uniqueness: true

  translates :name
  
  def to_formatted_json
    self.as_json(
      :include => {
        :sub_industries => {
          :only => [:id, :name], :include => {
            :production_processes => {:only => [:id, :name] }
          }
        }
      }
    )
  end
end
