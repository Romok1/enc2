# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
SITE_NAME = 'ncfa'
credentials = Rails.application.credentials[Rails.env.to_sym]

require "#{Rails.root}/lib/modules/importer"

Importer.destroy_all
Importer.import_all
Comfy::Cms::Site.create!(identifier: SITE_NAME, label: SITE_NAME, hostname: credentials[:comfy][:hostname])
# Rails::Task["comfy:cms_seeds:import[#{SITE_NAME}, #{SITE_NAME}]"].invoke

