require 'csv'

ECOSYSTEM_SERVICE_CSV = "#{Rails.root}/lib/data/seeds/ecosystem_services.csv".freeze

class SeedCsvsToEcosystemServices < ActiveRecord::Migration[5.2]
  def up
    # Only run if EcosystemServices exist in the db, if empty, the importer will handle this and the migration in unnecessary
    if EcosystemService.any?
      CSV.foreach(ECOSYSTEM_SERVICE_CSV, headers: true, encoding:'iso-8859-1:utf-8') do |row|
        ecosystem_service = EcosystemService.find_by_name(row['Ecosystem Service'].strip)
        ecosystem_service.update_attributes(url: row['URL'])
      end
    end
  end

  def down
    # Only run if EcosystemServices exist in the db, if empty, the importer will handle this and the migration in unnecessary
    if EcosystemService.any?
      EcosystemService.all.each do |es|
        es.update_attributes(url: nil)
      end
    end
  end
end
