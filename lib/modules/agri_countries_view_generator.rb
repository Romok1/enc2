require 'csv'
class AgriCountriesViewGenerator

  def initialize
    @country_file = "#{Rails.root}/lib/data/seeds/countries.csv"
    @query = agri_country_query
  end

  def generate_view
    Dir.mkdir(view_dir) unless Dir.exist?(view_dir)
    File.open("#{view_dir}/#{timestamp}.sql", 'w') { |f| f.write(@query) }
  end

  def agri_country_query
    <<-SQL
      SELECT * FROM countries
      WHERE iso_3 IN (#{country_list})
    SQL
  end

  def country_list
    agri_country_list = []
    CSV.foreach(@country_file, headers: true, encoding: 'utf-8') do |row|
      agri_country_list << row['ISO 3'] if row['Include for agriculture'] == '1'
    end
    agri_country_list.map { |a| "'#{a}'" }.join(',')
  end

  VIEW_DIR = 'db/views/agri_countries_view'.freeze
  def view_dir
    VIEW_DIR
  end

  def timestamp
    time = "#{Time.now.hour}#{Time.now.min}#{Time.now.sec}"
    Date.today.to_s.gsub('-', '') + time
  end
end
