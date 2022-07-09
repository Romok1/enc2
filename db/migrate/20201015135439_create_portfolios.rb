class CreatePortfolios < ActiveRecord::Migration[5.2]
  def change
    create_portfolios_table
    create_portfolios_sub_industries_table
    create_portfolios_production_processes_table
  end

  def create_portfolios_table
    create_table :portfolios do |t|
      t.string :name
      t.string :portfolio_type
      t.index :portfolio_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end

  def create_portfolios_sub_industries_table
    create_table :portfolios_sub_industries do |t|
      t.references :portfolio, foreign_key: true
      t.references :sub_industry, foreign_key: true

      t.timestamps
    end
  end

  def create_portfolios_production_processes_table
    create_table :portfolios_production_processes do |t|
      t.references :portfolio, foreign_key: true
      t.references :production_process, foreign_key: true

      t.timestamps
    end
  end
end
