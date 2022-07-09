class AlignmentOptionsController < ApplicationController
  def fetch_options
    @options = AlignmentOptionsFilter.filtering(params)

    @options = AlignmentOptionsFilter.sorting(@options, current_user)

    render json: @options
  end

  def dropdown_filters
    engagement_depth = AlignmentOption.pluck(:engagement_depth).uniq - ['Both']
    engagement_scope = AlignmentOption.pluck(:engagement_scope).uniq - ['Both']
    sbtn_step = AlignmentOption.pluck(:sbtn_step).uniq
    bio_metric = AlignmentOption.pluck(:biodiversity_metric).uniq.sort.reverse - ['Both']
    scenario = AlignmentOption.pluck(:future_scenario).uniq.compact - ['Both'] if params[:biodiversity_module] == 'agriculture'
    mitigation_hierarchy = AlignmentOption.pluck(:mitigation_hierarchy).uniq.compact - ['Avoid/Minimise'] if params[:biodiversity_module] == 'mining'
    filters = {
      engagement_depth: engagement_depth,
      engagement_scope: engagement_scope,
      sbtn_step: sbtn_step,
      biodiversity_metric: bio_metric
    }
    filters[:future_scenario] = scenario if params[:biodiversity_module] == 'agriculture'
    filters[:mitigation_hierarchy] = mitigation_hierarchy if params[:biodiversity_module] == 'mining'
    @data = filters.map do |k, v|
      { config: {
        id: k.to_s,
        name: I18n.t("biodiversity_goals.dashboard.shared.components.portfolio_options.filters.#{k}")
        },
        options: v.map { |value| { id: value.parameterize.underscore, name: value } }
      }
    end
    render json: @data
  end
end
