# frozen_string_literal: true

class NaturalCapitalDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_sub_industry_ids, only: %i[data flows_data]
  before_action :require_view_type, only: [:flows_data]
  include IndicatorsHelper

  def index
    @dashboard_tabs = I18n.t('natural_capital.dashboard.tabs')
    @flows_tabs = I18n.t('natural_capital.dashboard.flows.tabs').map do |tab|
      {
        id: tab.downcase,
        title: tab
      }
    end
  end

  # endpoint for main dependencies and impacts on dashboard
  def data
    @ecosystem_service_ids = []
    @impact_driver_ids = []

    @response = { # the order in which these are calculated is important!
      ecosystemServicesComponent: ecosystem_services_component,
      impactDriversComponent: impact_drivers_component,
      dependenciesAndImpactsComponent: dependencies_impacts_component,
      assetsComponent: assets_component
    }

    render json: @response
  end

  def flows_data
    # now we switch on type to see whether to pull dependencies or impacts from the db and format the response appropriately
    @response = []
    sub_industries.each do |si|
      si.production_processes.each do |pp|
        next unless production_processes.include?(pp)

        # add the production process link if it is in the list of prod_procs to include
        @response << {
          from: si.name,
          to: pp.name,
          value: 1
        }
      end
    end

    if view_type == 'dependencies'
      ess = []
      production_processes.each do |pp|
        pp.materialities.each do |m|
          @response << {
            from: pp.name,
            to: m.ecosystem_service.name,
            value: 1,
            icon: indicator_rating_class_from_join(m, 'materiality'),
            title: indicator_rating_text(m, 'materiality'),
            description: m.justification
          }
          ess << m.ecosystem_service unless ess.include?(m.ecosystem_service)
        end
      end

      ess.each do |es|
        es.ecosystem_services_assets_joins.each do |esaj|
          @response << {
            from: es.name,
            to: esaj.asset.name,
            value: 1,
            icon: indicator_rating_class_from_join(esaj, 'importance'),
            icon_svg: ActionController::Base.helpers.inline_svg('icons/Triangle.svg'),
            title: indicator_rating_text(esaj, 'importance'),
            description: esaj.justification
          }
        end
      end
    else # impacts
      ids = []
      production_processes.each do |pp|
        pp.impacts.each do |i|
          @response << {
            from: pp.name,
            to: i.impact_driver.name,
            value: 1,
            icon: indicator_rating_class_from_join(i, 'materiality'),
            title: indicator_rating_text(i, 'materiality'),
            description: i.justification
          }
          ids << i.impact_driver unless ids.include?(i.impact_driver)
        end
      end

      ds = []
      ids.each do |id|
        driver_count = 0

        id.drivers.each do |d|
          driver_count += 1
          ds << d unless ds.include?(d)
        end

        @response << {
          from: id.name,
          to: I18n.t('common.drivers'),
          value: driver_count,
          description: flows_impact_description(id.name, driver_count)
        }
      end

      assets = {}
      ds.each do |d|
        d.aggregated_assets_drivers_joins.each do |adj|
          asset_name = adj.asset.name
          assets[asset_name] = 1 if assets[asset_name].nil?

          assets[asset_name] += 1
        end
      end

      assets.each do |name, count|
        @response << {
          from: I18n.t('common.drivers'),
          to: name,
          value: count,
          description: flows_influence_description(name, count)
        }
      end
    end

    render json: @response
  end

  def portfolio
    render json: current_user.portfolios.natural_capital.find(params[:id])
  end

  private

  def flows_impact_description(name, count)
    I18n.t('natural_capital.dashboard.flows.impact_description', name: name, count: count, driver_total: driver_total)
  end

  def flows_influence_description(name, count)
    I18n.t('natural_capital.dashboard.flows.influence_description', name: name, count: count, driver_total: driver_total)
  end

  def driver_total
    Driver.all.count
  end

  def impact_driver_total
    ImpactDriver.all.count
  end

  def ecosystem_service_total
    EcosystemService.all.count
  end

  def require_sub_industry_ids
    return unless sub_industry_ids.nil? || sub_industry_ids.count.zero?

    render status: :bad_request, json: { message: 'Missing sub_industry_ids parameter' }
  end

  def require_view_type
    return unless view_type != 'dependencies' && view_type != 'impacts'

    render status: :bad_request, json: { message: 'Invalid type parameter' }
  end

  def view_type
    params[:type]
  end

  def production_processes
    production_processes = []
    # filter by production processes (if required)
    sub_industries.each do |sub_industry|
      sub_industry.production_processes.each do |production_process|
        next unless production_process_ids.nil? || production_process_ids.include?(production_process.id)
        next if production_processes.include?(production_process)

        production_processes << production_process
      end
    end

    production_processes.sort_by(&:name)
  end

  def sub_industries
    SubIndustry.find(sub_industry_ids)
  end

  def production_process_ids
    params[:production_process_ids]&.map(&:to_i)
  end

  def sub_industry_ids
    params[:sub_industry_ids]&.map(&:to_i)
  end

  def dependencies_impacts_component
    services = EcosystemService.find(@ecosystem_service_ids)
      .sort_by(&:name)
      .map { |es| { id: es.id, name: es.name } }
    impact_drivers = ImpactDriver.find(@impact_driver_ids)
      .sort_by(&:name)
      .map { |id| { id: id.id, name: id.name } }

    {
      ecosystemServices: {
        items: services,
        total: ecosystem_service_total
      },
      impactDrivers: {
        items: impact_drivers,
        total: impact_driver_total
      }
    }
  end

  def impact_drivers_component
    impact_ratings = materiality_ratings_template

    production_processes.each do |production_process|
      production_process.impacts.each do |impact|
        materiality_rating = impact_ratings.find { |impact_rating| impact_rating[:name] == impact.rag }
        unless materiality_rating.nil?
          materiality_impact_driver = materiality_rating[:entities].find do |impact_driver|
            impact_driver[:id] == impact.impact_driver.id
          end
        end
        if materiality_impact_driver.nil?
          # first time we've seen this ID, add to list
          materiality_rating[:entities] << {
            id: impact.impact_driver.id,
            name: impact.impact_driver.name,
            productionProcesses: [production_process]
          }
          push_to_impact_driver_ids_if_uniq_and_high_impact(impact)
        else
          # we've seen this ID before, just add the PP to it
          materiality_impact_driver[:productionProcesses] << production_process
        end
      end
    end

    sort_entities_in_ratings(impact_ratings)

    {
      materialities: impact_ratings,
      maxCount: impact_driver_total
    }
  end

  def ecosystem_services_component
    materiality_ratings = materiality_ratings_template

    production_processes.each do |production_process|
      production_process.materialities.each do |materiality|
        materiality_rating = materiality_ratings.find { |rating| rating[:name] == materiality.rag }
        unless materiality_rating.nil?
          materiality_ecosystem_service = materiality_rating[:entities].find do |ecosystem_service|
            ecosystem_service[:id] == materiality.ecosystem_service.id
          end
        end

        if materiality_ecosystem_service.nil?
          # first time we've seen this ES, add to list
          materiality_rating[:entities] << {
            id: materiality.ecosystem_service.id,
            name: materiality.ecosystem_service.name,
            productionProcesses: [production_process]
          }
          push_to_ecosystem_service_ids_if_uniq(materiality)
        else
          # we've seen this ES before, just add the PP to it
          materiality_ecosystem_service[:productionProcesses] << production_process
        end
      end
    end

    sort_entities_in_ratings(materiality_ratings)

    {
      materialities: materiality_ratings,
      maxCount: ecosystem_service_total
    }
  end

  def materiality_ratings_template
    [
      { name: 'VH', entities: [] },
      { name: 'H', entities: [] },
      { name: 'M', entities: [] },
      { name: 'L', entities: [] },
      { name: 'VL', entities: [] }
    ]
  end

  def sort_entities_in_ratings(ratings)
    ratings.each do |materiality_rating|
      materiality_rating[:entities].sort_by! { |e| e[:name] }
    end
  end

  def assets_component
    comp = {
      assets: [],
      ecosystemServiceTotal: ecosystem_service_total,
      impactDriverTotal: impact_driver_total
    }

    Asset.all.each do |asset|
      impact_drivers = asset.impact_drivers.find_all do |impact_driver|
        @impact_driver_ids.include?(impact_driver.id)
      end

      impact_driver_count = impact_drivers.count
      ecosystem_service_count = asset.ecosystem_services.where(id: @ecosystem_service_ids).count

      next if impact_driver_count.zero? && ecosystem_service_count.zero?

      comp[:assets] << {
        id: asset.id,
        name: asset.name,
        impactDriverCount: impact_driver_count,
        ecosystemServiceCount: ecosystem_service_count
      }
    end

    comp
  end

  def push_to_impact_driver_ids_if_uniq_and_high_impact(impact)
    is_high_impact_and_unique = %w[VH H].include?(impact.rag) &&
                                !@impact_driver_ids.include?(impact.impact_driver.id)

    @impact_driver_ids << impact.impact_driver.id if is_high_impact_and_unique
  end

  def push_to_ecosystem_service_ids_if_uniq(materiality)
    id = materiality.ecosystem_service.id

    @ecosystem_service_ids << id unless @ecosystem_service_ids.include?(id)
  end
end
