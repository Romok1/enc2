# frozen_string_literal: true

class AddRegionToCountries < ActiveRecord::Migration[5.2] # rubocop:disable Style/Documentation
  def up
    add_reference :countries, :region, foreign_key: true

    execute "DROP VIEW IF EXISTS agri_countries_view"
    execute "CREATE VIEW agri_countries_view AS #{File.read(Rails.root.join('db/views/agri_countries_view/20201120124029.sql'))}"
  end

  def down
    remove_reference :countries, :region
    execute "DROP VIEW IF EXISTS agri_countries_view"
  end
end
