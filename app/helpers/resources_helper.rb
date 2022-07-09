module ResourcesHelper
  def resource_sets
    resource_sets = []

    resource_set_names.each do |resource_set_name|
      resource_set = {
        id: resource_set_name.downcase.gsub(' ', '_'),
        name: resource_set_name,
        resources: resources(resource_set_name)
      }

      resource_sets.push(resource_set)
    end

    resource_sets
  end

  def resources(resource_set_name)
    entities.map { |entity| {
      name: entity[:name],
      id: entity[:id],
      features: datasets_by_feature(entity, resource_set_name)
    }}
  end

  def datasets_by_feature(entity, resource_set_name)
    entity[:features].map do |feature|
      datasets_by_feature = resource_set_name == 'Global' ? global_datasets(feature) : national_resource_datasets(feature, resource_set_name)
      datasets_by_feature.sort! { |a, b| a[:name] <=> b[:name] }

      {
        name: feature.name,
        datasets: datasets_by_feature
      }
    end
  end

  def global_datasets(feature)
    map_datasets = feature.datasets.uniq(&:resource_name)

    formatted_map_datasets = map_datasets.select(&:available).map { |dataset| {
      name: dataset.resource_name,
      url: dataset.url,
      on_map: true
    }}

    formatted_map_datasets + national_resource_datasets(feature, 'Global')
  end

  def national_resource_datasets(feature, resource_set_name)
    return [] unless feature.class.method_defined?(:national_resources)

    national_resources = feature.national_resources.select { |resource| resource[:region] == resource_set_name}

    national_resources.map! { |resource| {
      name: resource.name,
      url: resource.url,
      on_map: false
    }}
  end

  def resource_set_names
    (['Global'] + NationalResource.distinct.pluck(:region).sort).uniq
  end

  def entities
    [
      { id: 'asset', name: I18n.t('common.assets_short'), features: Asset.all },
      { id: 'driver', name: I18n.t('common.drivers_short'), features: Driver.all },
      { id: 'hotspots', name: I18n.t('common.hotspots'), features: Ecosystem.all },
      { id: 'impact_driver', name: I18n.t('common.impact_drivers'), features: ImpactDriver.all },
    ]
  end
end