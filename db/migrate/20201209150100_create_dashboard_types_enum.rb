class CreateDashboardTypesEnum < ActiveRecord::Migration[5.2]
  def up
    execute <<-DDL
      CREATE TYPE dashboard_types AS ENUM (
        'agriculture',
        'mining',
        'natural_capital'
      );
    DDL
  end

  def down
    execute 'DROP TYPE dashboard_types;'
  end
end
