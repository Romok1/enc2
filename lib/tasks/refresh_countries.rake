namespace :refresh do
  desc 'Refresh countries and update users'
  task countries: :environment do
    user_countries = user_country_mappings

    ActiveRecord::Base.transaction do
      User.update_all(country_id: nil)
      # Needed because it stores a reference to mines
      # which will get destroyed alongside countries
      MinesCompaniesJoin.destroy_all
      Country.destroy_all
      Importer.import_countries
      # Reimport all relationship which have been destroyed
      # alongside countries (cascade)
      Importer.import_mine_indicators
      Importer.import_mines_companies_join
      Importer.import_countries_ecoregions
      update_user_countries_with_mappings(user_countries)
    end
  end

  def user_country_mappings
    User.where.not(country_id: nil).map { |user| [user.id, user.country.iso_3] }.to_h
  end

  def update_user_countries_with_mappings(user_countries)
    user_countries.each do |id, country_iso_3|
      country = Country.find_by(iso_3: country_iso_3)
      User.where(id: id).update_all(country_id: country.id) if country
    end
  end
end