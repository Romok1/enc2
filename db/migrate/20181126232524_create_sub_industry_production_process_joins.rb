class CreateSubIndustryProductionProcessJoins < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_industry_production_process_joins do |t|
      t.references :sub_industry, foreign_key: true, index: {name: 'index_sub_industry_production_process'}
      t.references :production_process, foreign_key: true, index: {name: 'index_production_process_sub_industry'}
      t.timestamps
    end
  end
end
