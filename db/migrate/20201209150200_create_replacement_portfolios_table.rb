class CreateReplacementPortfoliosTable < ActiveRecord::Migration[5.2]
  def up
    create_table :portfolios do |t|
      t.string :name
      t.column :portfolio_type, :dashboard_types
      t.jsonb :request_structure
      t.references :user, foreign_key: true

      t.timestamps
    end

    # @see db/migrate/20201209150000_drop_portfolios_tables.rb
    # to understand how the import was intended to be received at this migration
    import_portfolios
  end

  def down
    drop_table :portfolios
  end

  private

  def import_portfolios
    file = Rails.root.join('tmp/portfolios.json')
    return unless File.exist?(file)

    json = File.read(file)
    ActiveRecord::Base.transaction do
      JSON.parse(json).each { |portfolio| create_portfolio(portfolio) }

      File.unlink(file)
    end
  end

  def create_portfolio(portfolio)
    Portfolio.create!({
      name: portfolio['name'],
      portfolio_type: portfolio['portfolio_type'],
      user_id: portfolio['user_id'],
      request_structure: {
        sub_industry_ids: portfolio['sub_industry_ids'],
        production_process_ids: portfolio['production_process_ids']
      },
      created_at: portfolio['created_at'],
      updated_at: portfolio['updated_at']
    })
  end
end
