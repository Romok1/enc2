class MapController < ApplicationController
  def index
    @ecosystem_services = EcosystemService.all
    @filter_pane_select_options = { dependencies: @ecosystem_services }.to_json
    @view = params[:view] || 'dependencies'
    @id = params[:id] || 1
    @selected_service = EcosystemService.find(@id).id
  end

  def assets
    asset = Asset.find(params[:id])

    resp = [{
      id: asset.id,
      name: asset.name,
      layers: clean_and_filter_datasets(asset.datasets)
    }]
    render json: resp
  end

  def drivers
    driver = Driver.find(params[:id])

    resp = [{
      id: driver.id,
      name: driver.name,
      layers: clean_and_filter_datasets(driver.datasets)
    }]
    render json: resp
  end

  def dependencies
    service = EcosystemService.find(params[:id])
    assets = service.assets
    drivers = Set[]

    assets.each do |asset|
      drivers.merge(asset.drivers)
    end

    resp = [
      {
        id: 1,
        name: I18n.t('common.assets'),
        facets: facets_for_map(assets)
      },
      {
        id: 2,
        name: I18n.t('common.drivers'),
        facets: facets_for_map(drivers)
      }
    ]

    render json: resp
  end

  def impacts
    resp = [{
      id: 1,
      name: I18n.t('common.impact_drivers'),
      facets: facets_for_map(ImpactDriver.all)
    }]

    render json: resp
  end

  def hotspots
    resp = [{
      id: 1,
      name: I18n.t('map.filter_pane_text.hotspots_title'),
      facets: facets_for_map(Ecosystem.all, false)
    }]

    render json: resp
  end

  private

  # mappables can be Ecosystems, Impact drivers, Drivers or Assets
  def facets_for_map(mappables, sort_by_name = true)
    datasets_by_mappable = []

    mappables.each do |mappable|
      datasets_by_mappable.push({
        id: mappable.id,
        name: mappable.name,
        layers: clean_and_filter_datasets(mappable.datasets)
      })
    end

    sort_by_name ? 
      datasets_by_mappable.sort_by { |d| d[:name] } : 
      datasets_by_mappable
  end

  def clean_and_filter_datasets(datasets)
    filtered_datasets = datasets.select{|ds| ds.available }

    filtered_datasets.each do |dataset|
      dataset = cleanDataset(dataset)
    end
  end

  def cleanDataset(dataset)
    if !dataset[:legend].nil?
      dataset[:legend] = dataset[:legend].tr(?', ?")
    end

    if !dataset[:filters].nil?
      dataset[:filters] = dataset[:filters].tr(?', ?")
    else
      dataset[:filters] = '[]'
    end

    if !dataset[:colors].nil?
      dataset[:colors] = dataset[:colors].tr(?', ?")
    end

    dataset
  end
end
