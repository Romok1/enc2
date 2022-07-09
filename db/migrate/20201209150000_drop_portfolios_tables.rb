class DropPortfoliosTables < ActiveRecord::Migration[5.2]
  def up
    export_portfolios
    drop_table :portfolios_sub_industries
    drop_table :portfolios_production_processes
    drop_table :portfolios
  end

  def down
    create_portfolios_table
    create_portfolios_sub_industries_table
    create_portfolios_production_processes_table
  end

  private

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

  def export_portfolios
    # @see db/migrate/20201209150200_create_replacement_portfolios_table.rb
    # where this export will be re-imported into the replacement table
    query = <<~QUERY
      select
        p.name,
        p.portfolio_type,
        p.user_id,
        (
          select array_agg(distinct psi.sub_industry_id)
          from portfolios_sub_industries as psi
          where p.id = psi.portfolio_id
        ) as sub_industry_ids,
        (
          select array_agg(distinct ppp.production_process_id)
          from portfolios_production_processes as ppp
          where p.id = ppp.portfolio_id
        ) as production_process_ids,
        p.created_at,
        p.updated_at
      from portfolios as p
    QUERY
    # the results need to be converted to their proper types
    # @see https://stackoverflow.com/q/25331778/1090438
    query_result = ActiveRecord::Base.connection.select_all(query)
    data = query_result.to_a.map { |o| o.each { |k, v| o[k] = query_result.column_types[k].cast(v) } }

    File.write(
      Rails.root.join('tmp/portfolios.json'),
      data.to_json
    )
  end
end
