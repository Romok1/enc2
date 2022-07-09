class CreateMinesCompaniesJoins < ActiveRecord::Migration[5.2]
  def up
    create_mines_companies_relationship_enum

    create_table :mines_companies_joins do |t|
      t.references :mine_indicator, foreign_key: true, index: true
      t.references :company, foreign_key: true, index: true
      t.column :relationship, :mines_companies_relationship

      t.timestamps
    end

  end

  def down
    drop_table :mines_companies_joins
    execute 'DROP TYPE mines_companies_relationship;'
  end

  private

  def create_mines_companies_relationship_enum
    execute <<-DDL
      CREATE TYPE mines_companies_relationship AS ENUM (
        'owner',
        'operator'
      );
    DDL
  end
end
