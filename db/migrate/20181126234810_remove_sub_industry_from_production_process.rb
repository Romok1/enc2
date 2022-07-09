class RemoveSubIndustryFromProductionProcess < ActiveRecord::Migration[5.2]
  def change
    remove_column :production_processes, :sub_industry_id
  end
end
